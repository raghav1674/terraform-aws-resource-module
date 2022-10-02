from datetime import datetime

def colored(r, g, b, text):
    return "\033[38;2;{};{};{}m{} \033[38;2;255;255;255m".format(r, g, b, text)
    
def red(text):
    return colored(230,20,5,f'Error::{datetime.now()}:: {text}')
def green(text):
    return colored(20,230,5,f'Success::{datetime.now()}:: {text}')
def blue(text):
    return colored(135,206,235,f'Info::{datetime.now()}:: {text}')