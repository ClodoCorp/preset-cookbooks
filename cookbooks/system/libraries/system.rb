class System
   def check_range(v, r)
      if v < r.min
	 return r.min
      elsif v > r.max
	 return r.max
      else
	 return v
      end
   end

   def convert(value, from, to)
      inc = 0
      case from
      when 'k'
               inc = 1
      when 'm'
               inc = 2
      when 'g'
               inc = 3
      when 't'
               inc = 4
      when 'p'
               inc = 5
      end
      dec = 0
      case to
      when 'k'
               dec = 1
      when 'm'
               dec = 2
      when 'g'
               dec = 3
      when 't'
               dec = 4
      when 'p'
               dec = 5
      end
      return (value.to_f*(1024**inc.to_f)/(1024**dec.to_f)).to_f
   end


   def m2b(value)
     return convert(value, 'm', 'b')
   end

   def b2m(value)
     return convert(value, 'b', 'm')
   end

   def g2b(value)
     return convert(value, 'g', 'b')
   end

   def b2k(value)
     return convert(value, 'b', 'k')
   end

   def k2b(value)
     return convert(value, 'k', 'b')
   end

   def cpus
      cpus = 0
      File.open("/proc/cpuinfo").each do |l|
	 case l
	 when /processor\s+:\s(.+)/
	    cpus += 1
	 end
      end
      if mem_min == mem_max
      #http://redmine.office.clodo.ru/issues/910
	if mem_min < g2b(4)
	  cpus = 4
	elsif mem_min >= g2b(4) && mem_min < g2b(12)
	  cpus = 8
	elsif mem_min >= g2b(12)
	  cpus = 14
	end
      else
      #scale servers always have max cpus, but limited to cpu by weight
        cpus = 14
      end
      return cpus
   end

   def mem_max
      bytes = 0 
      File.open("/proc/meminfo").each do |l|
	 case l
	 when /^MemTotal:\s+(\d+) (.+)$/
	    bytes = k2b($1.to_i)
	 end
      end
      File.open("/proc/cmdline").each do |l|
        case l
	when /uos_memmax=([0-9]+)/
	    bytes = m2b($1.to_i)
	end
      end
      return bytes
   end

   def mem_min
     bytes = 0
      File.open("/proc/meminfo").each do |l|
         case l
         when /^MemTotal:\s+(\d+) (.+)$/
            bytes = k2b($1.to_i)
         end
      end
      File.open("/proc/cmdline").each do |l|
        case l
        when /uos_memmin=([0-9]+)/
            bytes = m2b($1.to_i)
        end
      end
      return bytes
   end

end

#mi = MySQL_Instance.new(70, 70)
#puts(mi.mem_min())
#puts(mi.b2k(mi.mem_min()))
#puts(convert(1024 * 1024 * 2, 'b', 'm'))
#puts(convert(2, 'm', 'b'))
#mi = nil
