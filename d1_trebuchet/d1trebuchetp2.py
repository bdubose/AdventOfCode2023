
numbers = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9'
}

def find_first_digit(str: str, is_reversed: bool) -> int:
    char_mem = {
        'one': '',
        'two': '',
        'three': '',
        'four': '',
        'five': '',
        'six': '',
        'seven': '',
        'eight': '',
        'nine': ''
    }
    for char in str:
        if char.isdigit():
            # exit immediately if we're still searching and found an actual number
            return char
        for full, memory in char_mem.items():
            searching = full[::-1] if is_reversed else full
            next_char = searching.replace(memory, '', 1)[0] # next_char = (full - memory)[0]
            if char == next_char:
                if memory + char == searching:
                    return numbers[full]
                else:
                    # add this letter into the memory
                    char_mem[full] = memory + char


with open('./d1_trebuchet/data.txt', 'r') as file:
    coords_total = 0
    for line in file:
        first = find_first_digit(line, False)
        last = find_first_digit(line[::-1], True)
        print(f'first: {first}, last: {last}')
        coords_total = coords_total + int(first + last)

print(f'Grand total: {coords_total}')