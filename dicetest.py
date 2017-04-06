import random,re
a,b,c=re.findall("^(\d*)d(\d+)(\+\d+)?$",input())[0];t=int(c or 0)+(sum(random.randint(1,int(b))for i in range(int(a or 1)))or q)
print(t)
