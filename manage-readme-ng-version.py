import subprocess
import sys
from collections import OrderedDict

LATEST = '[latest](https://github.com/metal3d' + \
         '/docker-ng/blob/master/src/Dockerfile)'

images = subprocess.Popen(
        ["docker", "images", "metal3d/ng",
            "--format", "{{ .Tag }} {{ .ID }} {{ .Repository }}"],
        stdout=subprocess.PIPE)
sort = subprocess.Popen(
        ["sort", "-V", "-r"],
        stdin=images.stdout,
        stdout=subprocess.PIPE)

images.stdout.close()
versions = sort.communicate()[0].decode().strip().split('\n')

releases = OrderedDict()
for v in versions:
    version, imid, repo = v.split(' ')
    if 'docker.io' in repo:
        continue

    if imid not in releases:
        releases[imid] = []

    if 'latest' in version:
        version = LATEST

    releases[imid].append(version)

for _, v in releases.items():
    print(u'- ' + (u' ⇨ '.join(v)))
