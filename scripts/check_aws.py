import datetime
import json
import os
import sys
from pathlib import Path

home = str(Path.home())

def get_latest_file(path):
    """
    Returns the filename of the most recently updated file in the given directory path.
    """
    files = os.listdir(path)
    paths = [os.path.join(path, basename) for basename in files]
    paths.sort(key=os.path.getmtime, reverse=True)
    return paths[0]

def time_until(time_str):
    """
    Returns the timedelta between the current time and the time specified in the input string.
    """
    now = datetime.datetime.utcnow()
    target_datetime = datetime.datetime.strptime(time_str, '%Y-%m-%dT%H:%M:%SZ')
    if target_datetime < now:
        raise ValueError("Target time is in the past.")
    time_remaining = target_datetime - now
    minutes_remaining = round(time_remaining.total_seconds() / 60)
    seconds_remaining = minutes_remaining * 60
    timedelta_remaining = datetime.timedelta(seconds=seconds_remaining)
    return timedelta_remaining

output_file = "/tmp/aws_cli_time_left"
sso_cache_path = home + "/.aws/sso/cache"
sso_cache_file = get_latest_file(sso_cache_path)
with open(sso_cache_file) as sso_cache:
    sso_cache_dict = json.load(sso_cache)

exp_time = sso_cache_dict['expiresAt']
try:
    remaining = str(time_until(exp_time)).rsplit(':',1)[0]
    print(f"{remaining} remain")
    with open(output_file,"w") as f:
        f.write(str(remaining))
    sys.exit(0)
except ValueError:
    # print ('Token has expired! Run `aws sso login` to renew.')
    with open(output_file,"w") as f:
        f.write("expired")
    sys.exit(1)
