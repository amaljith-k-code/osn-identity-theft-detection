import csv

# Categories of words to help reach a high count
english_insults = ["idiot", "stupid", "loser", "trash", "dumb", "pathetic", "creep"]
manglish_insults = ["patti", "thendi", "mandan", "potta", "vazha", "kozhi", "chetta"]
# Suffixes common in Manglish bullying
suffixes = ["ye", "kale", "s", "da", "di"]

all_keywords = set()

# Add English
all_keywords.update(english_insults)

# Add Manglish base words
all_keywords.update(manglish_insults)

# Generate variations (e.g., patti + kale = pattikale)
for word in manglish_insults:
    for s in suffixes:
        all_keywords.add(word + s)

# Save to CSV
with open('bullying_keywords.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(["keyword"])
    for kw in sorted(all_keywords):
        writer.writerow([kw])

print(f"Generated {len(all_keywords)} keywords.")