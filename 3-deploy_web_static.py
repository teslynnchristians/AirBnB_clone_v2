#!/usr/bin/python3
"""
Fabric script that generates archive
"""

from datetime import datetime
from fabric.api import local, run, put, env
import os

env.hosts = ["3.95.133.255", "54.87.207.29"]
env.user = "ubuntu"


def do_pack():
    """
        Return the archive path if archive has been correctly
        gernerated.
    """

    local("mkdir -p versions")
    date = datetime.now().strftime("%Y%m%d%H%M%S")
    archived_f_path = "versions/web_static_{}.tgz".format(date)
    t_gzip_archive = local("tar -cvzf {} web_static".format(archived_f_path))

    if t_gzip_archive.succeeded:
        return archived_f_path
    else:
        return None


def do_deploy(archive_path):
    """
    a Fabric script that distributes an archive to your web servers
    """

    if not os.path.exists(archive_path):
        return False

    archived_file = archive_path[9:]
    newest_version = "/data/web_static/releases/" + archive_path[:-4]
    archived_file = "/tmp/" + archived_file

    put(archive_path, "/tmp/")
    run("sudo mkdir -p {}".format(newest_version))
    run("sudo tar -xzf {} -C {}/".format(archived_file, newest_version))
    run("sudo rm {}".format(archived_file))
    run("sudo mv {}/web_static/* {}".format(newest_version,
                                            newest_version))
    run("sudo rm -rf {}/web_static".format(newest_version))
    run("sudo rm -rf /data/web_static/current")
    run("sudo ln -s {} /data/web_static/current".format(newest_version))

    print("New version deployed!")
    return True


def deploy():
    """
    Deploy function do_pack and do_deploy.
    """
    path = do_pack()
    if path:
        do_deploy(path)
    return False
