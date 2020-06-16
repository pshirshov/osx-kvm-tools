#!/usr/bin/python3
cores=64
firstht = cores / 2

shift = 0
starta = 0 + shift
startb = firstht + shift
lastcore=cores-1
cc = 0

# reverse order is more beneficial, macos tends to load first CPUs first, so it 
# will load last host CPUs first

while cc < cores:
    print('    <vcpupin vcpu="%d" cpuset="%d"/>' % (cc, lastcore - starta))
    print('    <vcpupin vcpu="%d" cpuset="%d"/>' % (cc + 1, lastcore - startb))
    starta += 1
    startb += 1
    cc += 2


