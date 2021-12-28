from cs50 import get_string
import csv
import sys

sequence = ""
namesData = {}
sequenceID = ""


def countMax(sequence, part):
    maxCounter = 0
    tmp = 0
    tmp = sequence.count(part)
    tmpPart = part
    while tmp > 0:
        part += tmpPart
        maxCounter += 1
        tmp = sequence.count(part)
    return maxCounter
    

def main():
    # Ensure correct usage
    if len(sys.argv) != 3:
        sys.exit("Usage: python dna.py data.csv sequence.txt")
        
    # sequences =  second file, txt
    sequences = sys.argv[2]
    with open(sequences) as f:
        # sequence is a long string with DNA
        sequence = f.readline()
        f.close()
        
    # database = LARGE or SMALL CSV
    database = sys.argv[1]
    # if database = SMALL CSV
    if database == "databases/small.csv":
        with open(database) as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Key = name, Value = ID, where id is a unique id for each person which is a result of concatinating their DNA parameters
                namesData[row['name']] = row['AGATC'] + row['AATG'] + row['TATC']
        f.close()
        
        # looping through the dictionary
        sequenceID = format(countMax(sequence, 'AGATC')) + format(countMax(sequence, 'AATG')) + format(countMax(sequence, 'TATC'))
        for name, seqid in namesData.items():
            if seqid == sequenceID:
                print(name)
                return
        print('no match')
        
    # if database = LARGE CSV
    if database == "databases/large.csv":
        with open(database) as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Key = name, Value = DNA based unique ID
                namesData[row['name']] = row['AGATC'] + row['TTTTTTCT'] + row['AATG'] + \
                    row['TCTAG'] + row['GATA'] + row['TATC'] + row['GAAA'] + row['TCTG']
        f.close()
        
        sequenceID = format(countMax(sequence, 'AGATC')) + format(countMax(sequence, 'TTTTTTCT')) + format(countMax(sequence, 'AATG')) + format(countMax(sequence, 'TCTAG')) + \
            format(countMax(sequence, 'GATA')) + format(countMax(sequence, 'TATC')) + \
            format(countMax(sequence, 'GAAA')) + format(countMax(sequence, 'TCTG'))
        
        for name, seqid in namesData.items():
            if seqid == sequenceID:
                print(name)
                return
        print('no match')

  
main()
