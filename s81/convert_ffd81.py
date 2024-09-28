import csv
import re

input_file = 'ffd81.txt'
output_file = 's81_catalogue.csv'

pattern = re.compile(r'(\d+)(?:-\d+)?\.\d+\*?\s+\\COL\{([\d\s]+)\}.*?\\WLP\{([\d\s]*)\}')

with open(input_file, 'r') as infile, open(output_file, 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    
    writer.writerow(['num_of_columns', 'columns', 'wlp'])

    for line in infile:
        match = pattern.search(line)
        if match:
            line_number = match.group(1)
            col_numbers = match.group(2)
            wlp_numbers = match.group(3)
            writer.writerow([line_number, col_numbers, wlp_numbers])
