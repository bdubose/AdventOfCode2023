
from dataclasses import dataclass
import re

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
                self.symbol_locations.append(ix + 1)




lines = list()
with open('./d3_gear_ratios/data.txt', 'r') as file:
    for line in file:
        lines.append(Line(line))

# to determine adjacency:
# above & below: position overlap in either line-1 or line+1
# beside: position = postion+1 & same line
# diagonal: postion+1 overlay in either line-1 or line+1