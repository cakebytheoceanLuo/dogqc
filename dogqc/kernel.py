from dogqc.cudalang import *
from dogqc.code import Code
import dogqc.identifier as ident
from enum import IntEnum



class KernelCall ( object ):

    defaultGridSize = 1024
    defaultBlockSize = 128

    def __init__ ( self, gridSize, blockSize ):
        self.blockSize = KernelCall.defaultBlockSize
        self.gridSize = KernelCall.defaultGridSize
        if blockSize != None:
            self.blockSize = blockSize
        if gridSize != None:
            self.gridSize = gridSize

    def generated ( kernel, gridSize=None, blockSize=None ):
        call = KernelCall ( gridSize, blockSize )
        call.kernel = kernel
        call.kernelName = kernel.kernelName
        return call 
    
    def library ( kernelName, parameters, templateParameters="", gridSize=None, blockSize=None ):
        call = KernelCall ( gridSize, blockSize )
        call.kernel = None
        call.kernelName = kernelName
        call.parameters = parameters
        call.templateParameters = templateParameters
        return call 

    def get ( self ):
        if self.kernel != None:
            return KernelCall.generic ( self.kernel.kernelName, self.kernel.getParameters(), self.gridSize, self.blockSize )
        else:
            return KernelCall.generic ( self.kernelName, self.parameters, self.gridSize, self.blockSize )

    def getAnnotations ( self ):
        if self.kernel != None and len(self.kernel.annotations) > 0:
            return " ".join(self.kernel.annotations)
        else:
            return ""


    def generic ( kernelName, parameters, gridSize=1024, blockSize=128, templateParams="" ):
        # kernel invocation parameters
        code = Code()
    
        templatedKernel = kernelName
        if templateParams != "":
            templatedKernel += "<" + templateParams + ">"
    
        with Scope ( code ):
            emit ( "int gridsize=" + str(gridSize), code )
            emit ( "int blocksize=" + str(blockSize), code )
            call = templatedKernel + "<<<gridsize, blocksize>>>("
            # add parameters: input attributes, output attributes and additional variables (output number)
            comma = False
            for a in parameters:
                if not comma:
                    comma = True
                else:
                    call += ", " 
                call += str(a)
            call += ")"
            emit ( call, code )
        return code

    





class Kernel ( object ):
    
    def __init__ ( self, name ):
        self.init = Code()
        self.body = Code()
        self.inputColumns = {}
        self.outputAttributes = []
        self.variables = []
        self.kernelName = name
        self.annotations = []

    def add ( self, code ):
        self.body.add( code )
    
    def addVar ( self, c ):
        # resolve multiply added columns
        self.inputColumns [ c.get() ] = c

    def getParameters ( self ):
        params = []
        for name, c in self.inputColumns.items():
            params.append ( c.getGPU() )
        for a in self.outputAttributes:
            params.append ( ident.gpuResultColumn( a ) )
        for v in self.variables:
            params.append( v.getGPU() )
        return params

    def getKernelCode( self ):
        kernel = Code()
        
        # open kernel frame
        kernel.add("__global__ void " + self.kernelName + "(")
        comma = False
        params = ""
        for name, c in self.inputColumns.items():
            if not comma:
                comma = True
            else:
                params += ", " 
            params += c.dataType + "* " + c.get()
        for a in self.outputAttributes:
            params += ", " 
            params += a.dataType + "* " + ident.resultColumn( a )
        for v in self.variables:
            params += ", " 
            params += v.dataType + "* " + v.get()
        kernel.add( params + ") {")
        
        # add code generated by operator tree
        kernel.add(self.init.content)
        
        # add code generated by operator tree
        kernel.add(self.body.content)
        
        # close kernel frame
        kernel.add("}") 
        return kernel.content

    def annotate ( self, msg ):
        self.annotations.append(msg)


# For the only one device function: __device__ void sm_to_gm
class DeviceFunctionStatus ( IntEnum ):
    INIT    = 1 # not started
    STARTED = 2
    END  = 3

class DeviceFunction(object):
    def __init__(self, name):
        self.status = DeviceFunctionStatus.INIT
        self.init = Code()
        self.body = Code()
        self.inputColumns = {}
        # self.outputAttributes = []
        # self.variables = []
        self.functionName = name
        # self.annotations = []

    def add(self, code):
        self.body.add(code)

    def addFront(self, code):
        self.body.addFront(code)

    def addVar(self, c):
        # resolve multiply added columns
        self.inputColumns[c.get()] = c

    # def getParameters(self):
    #     params = []
    #     for name, c in self.inputColumns.items():
    #         params.append(c.getGPU())
    #     for a in self.outputAttributes:
    #         params.append(ident.gpuResultColumn(a))
    #     for v in self.variables:
    #         params.append(v.getGPU())
    #     return params

    def getDeviceFunction(self):
        kernel = Code()

        # open kernel frame
        kernel.add("__device__ void " + self.functionName + "(")
        comma = False
        params = ""
        for name, c in self.inputColumns.items():
            if not comma:
                comma = True
            else:
                params += ", "
            params += c.dataType + "* " + c.get()
        # for a in self.outputAttributes:
        #     params += ", "
        #     params += a.dataType + "* " + ident.resultColumn(a)
        # for v in self.variables:
        #     params += ", "
        #     params += v.dataType + "* " + v.get()
        kernel.add(params + ") {")

        # add code generated by operator tree
        kernel.add(self.init.content)

        # add code generated by operator tree
        kernel.add(self.body.content)

        # close kernel frame
        kernel.add("}")
        return kernel.content

    # def annotate(self, msg):
    #     self.annotations.append(msg)

