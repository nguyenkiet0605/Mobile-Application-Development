import sys
path='lib/screens/home_screen.dart'
stack=[]
with open(path,'r',encoding='utf-8') as f:
    for i,line in enumerate(f,1):
        for ch in line:
            if ch=='(':
                stack.append((i,ch))
            elif ch==')':
                if stack:
                    stack.pop()
                else:
                    print('unmatched ) at line',i)
if stack:
    print('unmatched ( remain:',len(stack))
    print(stack[-5:])
else:
    print('all parentheses matched!')
