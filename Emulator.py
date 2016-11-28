import dis

def fibo(a,b):
    r=0
    while b > 0:
        r=r+a
        b=b-1
    return r

print ("Disassembly: ")
dis.dis(fibo)
print ('\n')

hcode = [hex(x) for x in fibo.__code__.co_code]
dcode = [x for x in fibo.__code__.co_code]
cobj  = fibo.__code__
print ("Bytecode: ")
print (dcode)
print ('\n')

#args, 
opcodes = []

class ApoObject:    
    workingStack = []#reference to working stack
    varVals = []
    co_names = None #Tuples
    co_consts = None
    co_names = None
    co_code = None
    
    def __init__(self, a):
        pass

    def loadCodeObject(self, code):
        
        pass
    
    def evalCode(self):
        retVal = 0
        
        return retVal
    

    
def step(co):
    pc=0
    frameid=0
    code = [ord(x) for x in co.co_code]
    varnames = co.co_varnames
    consts = co.co_consts
    local = [None] * len(varnames)

    #Load Arguments
    argcount=co.co_argcount
    while argcount > 0:
        local[co.co_argcount-argcount] = int(raw_input(varnames[co.co_argcount-argcount]))
        argcount-=1
    
    while True:       
        print ("OP: ", code[pc], pc)
        print ("    Stack:", working)
        print ("VarsNames:", varnames)
        print ("    Local:", local)
        print (" ")
        
        #No arguments
        if code[pc] == 23: #BINARY_ADD 
            right = working.pop()
            left = working[-1]
            working.append(left + right)
            pc+=1
        elif code[pc] == 24: #BINARY_SUB 
            right = working.pop()
            left = working[-1]
            working.append(left - right)
            pc+=1
        elif code[pc] == 20: #BINARY_MULTIPLY
            right = working.pop()
            left = working[-1]
            working.append(left * right)
            pc+=1
        elif code[pc] == 27: #BINARY_TRUE_DIVIDE 
            right = working.pop()
            left = working[-1]
            working.append(left / right)
            pc+=1
        elif code[pc] == 66: #BINARY_OR 
            right = working.pop()
            left = working[-1]
            working.append(left | right)
            pc+=1
        elif code[pc] == 64: #BINARY_AND 
            right = working.pop()
            left = working[-1]
            working.append(left & right)
            pc+=1
        elif code[pc] == 65: #BINARY_XOR 
            right = working.pop()
            left = working[-1]
            working.append(left ^ right)
            pc+=1            

        #Has Arguments
        elif code[pc] == 100: #LOAD_CONST - Push constant onto stack
            working.append(consts[code[pc+1]])
            pc+=3        
            
        elif code[pc] == 120: #SETUP_LOOP - 
            print ("LOOP TO:", pc + code[pc+1]-1)
            print( "Loop BCode:", code[pc+3:(pc + code[pc+1]+2)])
            pc+=3
        
        elif code[pc] == 124: #LOAD_FAST - Push Local var onto stack
            working.append(local[code[pc+1]])
            pc+=3
            
        elif code[pc] == 125: #STORE_FAST - Store TOS in local varnames
            local[code[pc+1]]=working.pop()
            pc+=3
    
        elif code[pc] == 83: #RETURN_VALUE - Set retval
            retval = working.pop()
            print ("Return: ", retval)
            return retval
        
        else:
            return 'Bad opcode'
        print ("\n")
