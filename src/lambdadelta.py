from _lexer import Lexer

text_input = """
i32 main() {
	ret 1+2
}
"""

lexer = Lexer().get_lexer()
tokens = lexer.lex(text_input)
