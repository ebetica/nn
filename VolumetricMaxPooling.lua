local VolumetricMaxPooling, parent = torch.class('nn.VolumetricMaxPooling', 'nn.Module')

VolumetricMaxPooling.__version = 2

function VolumetricMaxPooling:__init(kT, kW, kH, dT, dW, dH, padT, padW, padH)
   parent.__init(self)

   dT = dT or kT
   dW = dW or kW
   dH = dH or kH

   self.kT = kT
   self.kH = kH
   self.kW = kW
   self.dT = dT
   self.dW = dW
   self.dH = dH

   self.padT = padT or 0
   self.padW = padW or 0
   self.padH = padH or 0


   self.ceil_mode = false
   self.indices = torch.Tensor()
end

function VolumetricMaxPooling:ceil()
    self.ceil_mode = true
    return self
end

function VolumetricMaxPooling:floor()
    self.ceil_mode = false
    return self
end

function VolumetricMaxPooling:updateOutput(input)
   self.indices = self.indices or input.new()
   input.THNN.VolumetricMaxPooling_updateOutput(
      input:cdata(),
      self.output:cdata(),
      self.indices:cdata(),
      self.kT, self.kW, self.kH,
      self.dT, self.dW, self.dH,
      self.padT, self.padW, self.padH,
      self.ceil_mode
   )
   return self.output
end

function VolumetricMaxPooling:updateGradInput(input, gradOutput)
   input.THNN.VolumetricMaxPooling_updateGradInput(
      input:cdata(),
      gradOutput:cdata(),
      self.gradInput:cdata(),
      self.indices:cdata(),
      self.dT, self.dW, self.dH,
      self.padT, self.padW, self.padH
   )
   return self.gradInput
end

function VolumetricMaxPooling:empty()
   self:clearState()
end

function VolumetricMaxPooling:clearState()
   if self.indices then self.indices:set() end
   return parent.clearState(self)
end

function VolumetricMaxPooling:read(file, version)
   parent.read(self, file)
   if version < 2 then
      self.ceil_mode = false
   end
end
