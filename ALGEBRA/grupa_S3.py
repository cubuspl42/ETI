sigma = [
    'abc',
    'acb',
    'bac',
    'bca',
    'cab',
    'cba'
]

for a in sigma:
    for b in sigma:
        c = ''.join([b['abc'.index(x)]for x in a])
        i = sigma.index(c)
        print(i, end="")
    print()
