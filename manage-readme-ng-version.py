import subprocess

images = subprocess.Popen(
        ["docker", "images", "metal3d/ng",
            "--format", "{{ .Tag }} {{ .ID }} {{ .Repository }}"],
        stdout=subprocess.PIPE)
sort = subprocess.Popen(
        ["sort", "-V"],
        stdin=images.stdout,
        stdout=subprocess.PIPE)

images.stdout.close()
versions = sort.communicate()[0].decode().strip().split('\n')
versions.sort(reverse=True)

releases = {}
for v in versions:
    version, imid, repo = v.split(' ')
    if 'docker.io' in repo:
        continue

    if imid not in releases:
        releases[imid] = []

    releases[imid].append(version)

for idx, (_, versions) in enumerate(releases.items()):
    versions = list(reversed(versions))

    end = ''
    if len(versions) > 1:
        end = '\n'

    print(end + '- ' + ' -> '.join(versions))

