import sys
start=int(sys.argv[1])
end=int(sys.argv[2])
with open('lib/screens/home_screen.dart','r',encoding='utf-8') as f:
    for i,line in enumerate(f,1):
        if start<=i<=end:
            print(f"{i:3}: {line.rstrip()}")
