import docker

cli = docker.from_env()

images = cli.images.list(name="metal3d")

tags = []
for i in images:
    rtags = []
    for rt in i.attrs['RepoTags']:
        if 'docker.io' in rt:
            continue
        if 'metal3d/ng:' not in rt:
            continue
        tag = rt.split(':')[1]
        rtags.append(tag)

    if len(rtags) > 0:
        rtags.sort()
        tags.append(rtags)

tags.sort()
for t in tags:
    t.sort(reverse=True)
    listing = []
    islatest = False
    for tag in t:
        if tag == 'latest':
            islatest = True
            continue
        listing.append(tag)
    if islatest:
        listing.append('latest')

    out = ['`%s`' % l for l in listing]
    print("- " + ", ".join(out))
