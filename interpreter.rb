#!/usr/bin/ruby

module Constants
  LabelSpaces = " "*4
end

$registers = {} 
$labels    = {}
$flags     = nil 
$stack     = []

Instruction = Struct.new(:mnemonic, :args)

def parse_instruction(instruction)
  delim_idx = instruction.index(" ")
  if delim_idx.nil?
    mnemonic = instruction
    args = []
  else
    mnemonic  = instruction[0...delim_idx]
    args      = instruction[delim_idx..-1].split(",").map(&:strip)
  end
  return Instruction.new(mnemonic, args)
end

def parse(program)
  result = []
  lines = program.split("\n")
  i = 0
  while(lines[i])
    line = lines[i]
    if line.delete(" ").empty? || line.lstrip.start_with?(";")
      i += 1
      next
    end

    pp line

    # cleanup the line from comments and newlines
    line = line[0...line.index(";")].rstrip
    # this part might be used for future parsing of static data like strings 
    if line.end_with?(":")
      # label
      label_name = line.delete(":")
      $labels[label_name] = []
      i += 1
      while(lines[i] && lines[i].start_with?(Constants::LabelSpaces))
        $labels[label_name] << parse_instruction(lines[i].strip)
        i += 1
      end
    else
      # instruction
      result << parse_instruction(line) 
    end
    i += 1
  end
  return result
end

def execute(program, is_parsed = false)
  if is_parsed 
    parsed_prog = program
  else
    parsed_prog = parse(program)
  end
  pp parsed_prog
  parsed_prog.each do |instruction|
    case instruction.mnemonic
      when "mov" 
        operand1 = instruction.args[0]
        operand2 = instruction.args[1]
        if operand2.match?(/\d+/)
          # immediate
          $registers[operand1] = operand2.to_i
        else
          $registers[operand1] = $registers[operand2]
        end

      when "inc"
        operand1 = instruction.args[0]
        $registers[operand1] += 1
      when "dec"
        operand1 = instruction.args[0]
        $registers[operand1] -= 1

      when "push"
        operand1 = instruction.args[0]
        if operand1.match?(/\d+/)
          # immediate
          $stack.push(operand1.to_i)
        else
          $stack.push($registers[operand1])
        end
      when "pop"
        operand1 = instruction.args[0]
        $registers[operand1] = $stack.pop()
      when "call"
        function = instruction.args[0]
        execute($labels[function], true)
      when "div"
        operand1 = instruction.args[0]
        operand2 = instruction.args[1]
        if operand2.match?(/\d+/)
          # immediate
          $registers[operand1] /= operand2.to_i
        else
          $registers[operand1] /= $registers[operand2]
        end
      when "mul"
        operand1 = instruction.args[0]
        operand2 = instruction.args[1]
        if operand2.match?(/\d+/)
          # immediate
          $registers[operand1] *= operand2.to_i
        else
          $registers[operand1] *= $registers[operand2]
        end
      when "ret"
        return
      when "msg"
        out = instruction.args[0].delete("'")
        instruction.args[1..-1].each do |arg|
          if arg.include?("'")
            # text string
            out += arg.delete("'")
          else
            # register
            reg = $registers[arg].to_s
            out += reg
          end
        end
        puts(out)
      when "cmp"
        raise "cmp is expected to have 2 arguments!" if instruction.args.size < 2
        operand1 = instruction.args[0]
        operand2 = instruction.args[1]
        if operand2.match?(/\d+/)
          # immediate
          $flags = $registers[operand1] - operand2.to_i
        else
          $flags = $registers[operand1] - $registers[operand2]
        end
      when "jne"
        label = instruction.args[0]
        if $flags != 0
          execute($labels[label], true)
          return # after jmp
        end
      when "je"
        label = instruction.args[0]
        if $flags == 0
          execute($labels[label], true)
          return # after jmp
        end
      when "jg"
        label = instruction.args[0]
        if $flags > 0
          execute($labels[label], true)
          return # after jmp
        end
      when "jge"
        label = instruction.args[0]
        if $flags >= 0
          execute($labels[label], true)
          return # after jmp
        end
      when "jl"
        label = instruction.args[0]
        if $flags < 0
          execute($labels[label], true)
          return # after jmp
        end
      when "jle"
        label = instruction.args[0]
        if $flags <= 0
          execute($labels[label], true)
          return # after jmp
        end
      when "end"
        puts "END"
        exit(0)
      else 
        puts "Dumping current state..."
        pp $registers
        raise "unknown instruction #{instruction.mnemonic}"
    end
  end
end

# this is just a demo
program = "
; demo
; ecx -> base
; edx -> exponent
; eax -> result
mov eax, 1
pow:
    mul eax, ecx
    dec edx
    cmp edx, 0
    jne pow
    ret

mov ecx, 5
mov edx, 2
call pow
msg 'pow: ', eax
end
"

raise "please provide a file name!" unless ARGV[0]
raise "file doesn't exist" unless File.exist?(ARGV[0])
source = File.read(ARGV[0])
execute(source)
