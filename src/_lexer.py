from rply import LexerGenerator

class Lexer():
    def __init__(self):
        self.lexer = LexerGenerator()

    def _add_tokens(self):
        
        self.lexer.add('PROC', r'proc')
        
        self.lexer.add('OPEN_PAREN', r'\(')
        self.lexer.add('CLOSE_PAREN', r'\)')
        
        self.lexer.add('SEMI_COLON', r'\;')

        self.lexer.add('OPEN_CURLY', r'\{')
        self.lexer.add('CLOSE_CURLY', r'\}')

        self.lexer.add('NUMBER', r'\d+')

        self.lexer.ignore('\s+')
 
        self.lexer.add('INT32', r'i32')
 
        self.lexer.add('RET', r'ret')
 
        self.lexer.add('MAIN', r'main')

        self.lexer.add('PLUS', r'\+')

    def get_lexer(self):
        self._add_tokens()
        return self.lexer.build()

'''
i32 main() {
	ret 1+2
}
'''
