
from dataclasses import dataclass

@dataclass
class PartNumber:
    value: int
    start_pos: int
    end_pos: int
    is_confirmed: bool

class Line:
    def __init__(self, input: str):
        self.part_numbers = list()
        self.symbol_locations = list()
        number_mem = ''
        start = -1
        for ix, char in enumerate(input.strip()):
            if char == '.':
                if number_mem != '':
                    self.part_numbers.append(PartNumber(int(number_mem), start + 1, ix + 1, False))
                    number_mem = ''
                    start = -1
                continue
            
            if char.isdigit():
                start = ix if start == -1 else start
                number_mem = number_mem + char
            else:
                self.symbol_locations.append(ix + 2)




lines = list()
with open('./d3_gear_ratios/data.txt', 'r') as file:
    for line in file:
        lines.append(Line(line))


for ix, line in enumerate(lines):
    for part in line.part_numbers:
        if part.start_pos - 1 in line.symbol_locations or \
            part.end_pos in line.symbol_locations or \
            (ix > 0 and any([i for i in range(part.start_pos, part.end_pos) if i in lines[ix - 1].symbol_locations])) or \
            (ix < len(lines) - 1 and any([i for i in range(part.start_pos, part.end_pos) if i in lines[ix + 1].symbol_locations])):
            part.is_confirmed = True
            
# too high 1123059
print(sum([ pn.value for l in lines for pn in l.part_numbers if pn.is_confirmed]))

# to determine adjacency:
# above & below: position overlap in either line-1 or line+1
# beside: position = postion+1 & same line
# diagonal: postion+1 overlay in either line-1 or line+1