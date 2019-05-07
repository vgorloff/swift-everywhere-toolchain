class Arch

   def self.default
      return armv7a
   end

   # Fixme. Seems `x86` can be used instead.
   def self.host
      return "darwin"
   end

   def self.x86
      return "x86"
   end

   def self.armv7a
      return "armv7a"
   end

   def self.aarch64
      return "aarch64"
   end

end
