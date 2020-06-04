import pyperclip, re

text = pyperclip.paste()
regex = re.compile('(\w+)\.(\w+)')

text = regex.sub(r'"\2"', text)

regex = re.compile('				')
text = regex.sub("	", text)

regex = re.compile('\'')
text = regex.sub('"', text)

pyperclip.copy(text)
