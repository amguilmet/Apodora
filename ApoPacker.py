import dis,types

def test(a,b):
    r=0
    while b>0:
        r=r+a
        b=b-1
    return r

class ApoPacker:
    memory=[]

    def __init__(self):
        pass

    def packCodeObj(self, func):
        packCode     = [ord(x) for x in func.co_code]
        print len(packCode), packCode

        packNames    = func.co_names
        print packNames, packNames.count(packNames)
        
        packConstTuple = func.co_consts #these vary in types so there must be a type id
        packConst = []
        for x in packConstTuple:
            for i, typesIter in enumerate(types.__all__):
                print "Iter: ", typesIter== type(x)
                if isinstance(x, typesIter):
                    packConst+=i
                
        print packConst
        
        packVarNames = func.co_varnames
        print packVarNames
        
a=ApoPacker()
b=a.packCodeObj(test.func_code)
