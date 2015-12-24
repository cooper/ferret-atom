describe "ferret grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-ferret")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.ferret")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.ferret"

  describe "when a regexp compile tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("qr/text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.ferret", "string.regexp.compile.simple-delimiter.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.compile.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.compile.simple-delimiter.ferret"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.compile.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.compile.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qr(text)acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.compile.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qr{text}acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.ferret", "string.regexp.compile.nested_braces.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.ferret", "string.regexp.compile.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.compile.nested_braces.ferret"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.ferret", "string.regexp.compile.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.compile.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qr[text]acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.ferret", "string.regexp.compile.nested_brackets.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.ferret", "string.regexp.compile.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.compile.nested_brackets.ferret"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.ferret", "string.regexp.compile.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.compile.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qr<text>acdegilmoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.ferret", "string.regexp.compile.nested_ltgt.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.ferret", "string.regexp.compile.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.compile.nested_ltgt.ferret"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.ferret", "string.regexp.compile.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.compile.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

    it "does not treat $) as a variable", ->
      {tokens} = grammar.tokenizeLine("qr(^text$);")
      expect(tokens[2]).toEqual value: "^text", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret"]
      expect(tokens[3]).toEqual value: "$", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.compile.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.ferret"]

    it "does not treat ( in a class as a group", ->
      {tokens} = grammar.tokenizeLine("m/ \\A [(]? [?] .* - /smx")
      expect(tokens[1]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "[", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret"]
      expect(tokens[6]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret"]
      expect(tokens[7]).toEqual value: "]", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret"]
      expect(tokens[13]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[14]).toEqual value: "smx", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

    it "does not treat 'm'(hashkey) as a regex match begin", ->
      {tokens} = grammar.tokenizeLine("$foo->{m}->bar();")
      expect(tokens[3]).toEqual value: "{", scopes: ["source.ferret"]
      expect(tokens[4]).toEqual value: "m", scopes: ["source.ferret", "constant.other.bareword.ferret"]
      expect(tokens[5]).toEqual value: "}", scopes: ["source.ferret"]

  describe "when a regexp find tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine(" =~ /text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine(" =~ m/text/acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find-m.simple-delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine(" =~ m(text)acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.ferret", "string.regexp.find-m.nested_parens.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[2]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.find-m.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find-m.nested_parens.ferret"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.find-m.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine(" =~ m{text}acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.ferret", "string.regexp.find-m.nested_braces.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[2]).toEqual value: "{", scopes: ["source.ferret", "string.regexp.find-m.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find-m.nested_braces.ferret"]
      expect(tokens[4]).toEqual value: "}", scopes: ["source.ferret", "string.regexp.find-m.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine(" =~ m[text]acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.ferret", "string.regexp.find-m.nested_brackets.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[2]).toEqual value: "[", scopes: ["source.ferret", "string.regexp.find-m.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find-m.nested_brackets.ferret"]
      expect(tokens[4]).toEqual value: "]", scopes: ["source.ferret", "string.regexp.find-m.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine(" =~ m<text>acdegilmoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.ferret", "string.regexp.find-m.nested_ltgt.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[2]).toEqual value: "<", scopes: ["source.ferret", "string.regexp.find-m.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.find-m.nested_ltgt.ferret"]
      expect(tokens[4]).toEqual value: ">", scopes: ["source.ferret", "string.regexp.find-m.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.find-m.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.ferret"]

    it "works with without any character before a regexp", ->
      {tokens} = grammar.tokenizeLine("/asd/")
      expect(tokens[0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[1]).toEqual value: "asd", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]

      {tokens} = grammar.tokenizeLine(" /asd/")
      expect(tokens[0]).toEqual value: " ", scopes: ["source.ferret"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "asd", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]

      lines = grammar.tokenizeLines("""$asd =~
      /asd/;""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.ferret"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][1]).toEqual value: "asd", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(lines[1][2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][3]).toEqual value: ";", scopes: ["source.ferret"]

    it "works with control keys before a regexp", ->
      {tokens} = grammar.tokenizeLine("if /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]

      {tokens} = grammar.tokenizeLine("unless /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]

    it "works with multiline regexp", ->
      lines = grammar.tokenizeLines("""$asd =~ /
      (\\d)
      /x""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.ferret"]
      expect(lines[0][3]).toEqual value: " ", scopes: ["source.ferret"]
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][0]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(lines[1][2]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(lines[2][1]).toEqual value: "x", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

    it "does not highlight a divide operation", ->
      {tokens} = grammar.tokenizeLine("my $foo = scalar(@bar)/2;")
      expect(tokens[9]).toEqual value: ")/2;", scopes: ["source.ferret"]

    it "works in a if", ->
      {tokens} = grammar.tokenizeLine("if (/ hello /i) {}")
      expect(tokens[1]).toEqual value: " (", scopes: ["source.ferret"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[3]).toEqual value: " hello ", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "i", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[6]).toEqual value: ") {}", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("if ($_ && / hello /i) {}")
      expect(tokens[5]).toEqual value: " ", scopes: ["source.ferret"]
      expect(tokens[6]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[7]).toEqual value: " hello ", scopes: ["source.ferret", "string.regexp.find.ferret"]
      expect(tokens[8]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[9]).toEqual value: "i", scopes: ["source.ferret", "string.regexp.find.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]
      expect(tokens[10]).toEqual value: ") {}", scopes: ["source.ferret"]

  describe "when a regexp replace tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("s/text/test/acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret"]
      expect(tokens[5]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[6]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

      {tokens} = grammar.tokenizeLine("s(text)(test)acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.nested_parens.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.nested_parens.ferret"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "(", scopes: ["source.ferret", "string.regexp.format.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.format.nested_parens.ferret"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.ferret", "string.regexp.format.nested_parens.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

      {tokens} = grammar.tokenizeLine("s{text}{test}acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.nested_braces.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.ferret", "string.regexp.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.nested_braces.ferret"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.ferret", "string.regexp.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "{", scopes: ["source.ferret", "string.regexp.format.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.format.nested_braces.ferret"]
      expect(tokens[6]).toEqual value: "}", scopes: ["source.ferret", "string.regexp.format.nested_braces.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

      {tokens} = grammar.tokenizeLine("s[text][test]acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.nested_brackets.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.ferret", "string.regexp.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.nested_brackets.ferret"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.ferret", "string.regexp.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "[", scopes: ["source.ferret", "string.regexp.format.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.format.nested_brackets.ferret"]
      expect(tokens[6]).toEqual value: "]", scopes: ["source.ferret", "string.regexp.format.nested_brackets.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

      {tokens} = grammar.tokenizeLine("s<text><test>acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.nested_ltgt.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.ferret", "string.regexp.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.nested_ltgt.ferret"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.ferret", "string.regexp.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "<", scopes: ["source.ferret", "string.regexp.format.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.format.nested_ltgt.ferret"]
      expect(tokens[6]).toEqual value: ">", scopes: ["source.ferret", "string.regexp.format.nested_ltgt.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[7]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

      {tokens} = grammar.tokenizeLine("s_text_test_acdegilmoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret", "punctuation.definition.string.ferret", "support.function.ferret"]
      expect(tokens[1]).toEqual value: "_", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret"]
      expect(tokens[3]).toEqual value: "_", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret"]
      expect(tokens[5]).toEqual value: "_", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(tokens[6]).toEqual value: "acdegilmoprsux", scopes: ["source.ferret", "string.regexp.replace.ferret", "punctuation.definition.string.ferret", "keyword.control.regexp-option.ferret"]

    it "works with two '/' delimiter in the first line, and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);/
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[0][8]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replaceXXX.format.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[2][2]).toEqual value: ";", scopes: ["source.ferret"]

    it "works with one '/' delimiter in the first line, one in the next and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[3][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[3][2]).toEqual value: ";", scopes: ["source.ferret"]

    it "works with one '/' delimiter in the first line and two in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /chr($1)/gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][5]).toEqual value: "/", scopes: ["source.ferret", "string.regexp.replace.extended.simple_delimiter.ferret", "punctuation.definition.string.ferret"]
      expect(lines[1][7]).toEqual value: ";", scopes: ["source.ferret"]

  describe "tokenizes constant variables", ->
    it "highlights constants", ->
      {tokens} = grammar.tokenizeLine("__FILE__")
      expect(tokens[0]).toEqual value: "__FILE__", scopes: ["source.ferret", "constant.language.ferret"]

      {tokens} = grammar.tokenizeLine("__LINE__")
      expect(tokens[0]).toEqual value: "__LINE__", scopes: ["source.ferret", "constant.language.ferret"]

      {tokens} = grammar.tokenizeLine("__PACKAGE__")
      expect(tokens[0]).toEqual value: "__PACKAGE__", scopes: ["source.ferret", "constant.language.ferret"]

      {tokens} = grammar.tokenizeLine("__SUB__")
      expect(tokens[0]).toEqual value: "__SUB__", scopes: ["source.ferret", "constant.language.ferret"]

      {tokens} = grammar.tokenizeLine("__END__")
      expect(tokens[0]).toEqual value: "__END__", scopes: ["source.ferret", "constant.language.ferret"]

      {tokens} = grammar.tokenizeLine("__DATA__")
      expect(tokens[0]).toEqual value: "__DATA__", scopes: ["source.ferret", "constant.language.ferret"]

    it "does highlight custom constants different", ->
      {tokens} = grammar.tokenizeLine("__TEST__")
      expect(tokens[0]).toEqual value: "__TEST__", scopes: ["source.ferret", "string.unquoted.program-block.ferret", "punctuation.definition.string.begin.ferret"]

  describe "tokenizes compile phase keywords", ->
    it "does highlight all compile phase keywords", ->
      {tokens} = grammar.tokenizeLine("BEGIN")
      expect(tokens[0]).toEqual value: "BEGIN", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

      {tokens} = grammar.tokenizeLine("UNITCHECK")
      expect(tokens[0]).toEqual value: "UNITCHECK", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

      {tokens} = grammar.tokenizeLine("CHECK")
      expect(tokens[0]).toEqual value: "CHECK", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

      {tokens} = grammar.tokenizeLine("INIT")
      expect(tokens[0]).toEqual value: "INIT", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

      {tokens} = grammar.tokenizeLine("END")
      expect(tokens[0]).toEqual value: "END", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

      {tokens} = grammar.tokenizeLine("DESTROY")
      expect(tokens[0]).toEqual value: "DESTROY", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]

  describe "tokenizes method calls", ->
    it "does not highlight if called like a method", ->
      {tokens} = grammar.tokenizeLine("$test->q;")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.ferret", "keyword.operator.comparison.ferret"]
      expect(tokens[3]).toEqual value: "q;", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("$test->q();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.ferret", "keyword.operator.comparison.ferret"]
      expect(tokens[3]).toEqual value: "q();", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("$test->qq();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.ferret", "keyword.operator.comparison.ferret"]
      expect(tokens[3]).toEqual value: "qq();", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("$test->qw();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.ferret", "keyword.operator.comparison.ferret"]
      expect(tokens[3]).toEqual value: "qw();", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("$test->qx();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.ferret", "keyword.operator.comparison.ferret"]
      expect(tokens[3]).toEqual value: "qx();", scopes: ["source.ferret"]

  describe "when a function call tokenizes", ->
    it "does not highlight calls which looks like a regexp", ->
      {tokens} = grammar.tokenizeLine("s_ttest($key,\"t_storage\",$single_task);")
      expect(tokens[0]).toEqual value: "s_ttest(", scopes: ["source.ferret"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.ferret"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.ferret"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("s__ttest($key,\"t_license\",$single_task);")
      expect(tokens[0]).toEqual value: "s__ttest(", scopes: ["source.ferret"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.ferret"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.ferret"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.ferret"]

  describe "tokenizes single quoting", ->
    it "does not escape characters in single-quote strings", ->
      {tokens} = grammar.tokenizeLine("'Test this\\nsimple one';")
      expect(tokens[0]).toEqual value: "'", scopes: ["source.ferret", "string.quoted.single.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.ferret", "string.quoted.single.ferret"]
      expect(tokens[2]).toEqual value: "'", scopes: ["source.ferret", "string.quoted.single.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("q(Test this\\nsimple one);")
      expect(tokens[0]).toEqual value: "q(", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("q~Test this\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "q~", scopes: ["source.ferret", "string.quoted.other.q.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test this\\nadvanced one", scopes: ["source.ferret", "string.quoted.other.q.ferret"]
      expect(tokens[2]).toEqual value: "~", scopes: ["source.ferret", "string.quoted.other.q.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.ferret"]

    it "does not escape characters in single-quote multiline strings", ->
      lines = grammar.tokenizeLines("""q(
      This is my first line\\n
      and this the second one\\x00
      last
      );""")
      expect(lines[0][0]).toEqual value: "q(", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.begin.ferret"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret"]
      expect(lines[2][0]).toEqual value: "and this the second one\\x00", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret"]
      expect(lines[4][0]).toEqual value: ")", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.end.ferret"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.ferret"]

      lines = grammar.tokenizeLines("""q~
      This is my first line\\n
      and this the second one)\\x00
      last
      ~;""")
      expect(lines[0][0]).toEqual value: "q~", scopes: ["source.ferret", "string.quoted.other.q.ferret", "punctuation.definition.string.begin.ferret"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.ferret", "string.quoted.other.q.ferret"]
      expect(lines[2][0]).toEqual value: "and this the second one)\\x00", scopes: ["source.ferret", "string.quoted.other.q.ferret"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.ferret", "string.quoted.other.q.ferret"]
      expect(lines[4][0]).toEqual value: "~", scopes: ["source.ferret", "string.quoted.other.q.ferret", "punctuation.definition.string.end.ferret"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.ferret"]

    it "does not highlight the whole word as an escape sequence", ->
      {tokens} = grammar.tokenizeLine("\"I l\\xF6ve th\\x{00E4}s\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.ferret", "string.quoted.double.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "I l", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[2]).toEqual value: "\\xF6", scopes: ["source.ferret", "string.quoted.double.ferret", "constant.character.escape.ferret"]
      expect(tokens[3]).toEqual value: "ve th", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[4]).toEqual value: "\\x{00E4}", scopes: ["source.ferret", "string.quoted.double.ferret", "constant.character.escape.ferret"]
      expect(tokens[5]).toEqual value: "s", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.ferret", "string.quoted.double.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.ferret"]

  describe "tokenizes double quoting", ->
    it "does escape characters in double-quote strings", ->
      {tokens} = grammar.tokenizeLine("\"Test\\tthis\\nsimple one\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.ferret", "string.quoted.double.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.ferret", "string.quoted.double.ferret", "constant.character.escape.ferret"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.ferret", "string.quoted.double.ferret", "constant.character.escape.ferret"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.ferret", "string.quoted.double.ferret"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.ferret", "string.quoted.double.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qq(Test\\tthis\\nsimple one);")
      expect(tokens[0]).toEqual value: "qq(", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret", "constant.character.escape.ferret"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret", "constant.character.escape.ferret"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.ferret", "string.quoted.other.qq-paren.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.ferret"]

      {tokens} = grammar.tokenizeLine("qq~Test\\tthis\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "qq~", scopes: ["source.ferret", "string.quoted.other.qq.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.ferret", "string.quoted.other.qq.ferret"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.ferret", "string.quoted.other.qq.ferret", "constant.character.escape.ferret"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.ferret", "string.quoted.other.qq.ferret"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.ferret", "string.quoted.other.qq.ferret", "constant.character.escape.ferret"]
      expect(tokens[5]).toEqual value: "advanced one", scopes: ["source.ferret", "string.quoted.other.qq.ferret"]
      expect(tokens[6]).toEqual value: "~", scopes: ["source.ferret", "string.quoted.other.qq.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.ferret"]

  describe "tokenizes word quoting", ->
    it "quotes words", ->
      {tokens} = grammar.tokenizeLine("qw(Aword Bword Cword);")
      expect(tokens[0]).toEqual value: "qw(", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.begin.ferret"]
      expect(tokens[1]).toEqual value: "Aword Bword Cword", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.ferret", "string.quoted.other.q-paren.ferret", "punctuation.definition.string.end.ferret"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.ferret"]

  describe "tokenizes subroutines", ->
    it "does highlight subroutines", ->
      lines = grammar.tokenizeLines("""sub mySub {
          print "asd";
      }""")
      expect(lines[0][0]).toEqual value: "sub", scopes: ["source.ferret", "meta.function.ferret", "storage.type.sub.ferret"]
      expect(lines[0][2]).toEqual value: "mySub", scopes: ["source.ferret", "meta.function.ferret", "entity.name.function.ferret"]
      expect(lines[0][4]).toEqual value: "{", scopes: ["source.ferret"]
      expect(lines[2][0]).toEqual value: "}", scopes: ["source.ferret"]

    it "does highlight subroutines assigned to a variable", ->
      lines = grammar.tokenizeLines("""my $test = sub {
          print "asd";
      };""")
      expect(lines[0][5]).toEqual value: "sub", scopes: ["source.ferret", "meta.function.ferret", "storage.type.sub.ferret"]
      expect(lines[0][7]).toEqual value: "{", scopes: ["source.ferret"]
      expect(lines[2][0]).toEqual value: "};", scopes: ["source.ferret"]

    it "does highlight subroutines assigned to a hash key", ->
      lines = grammar.tokenizeLines("""my $test = { a => sub {
          print "asd";
      }};""")
      expect(lines[0][9]).toEqual value: "sub", scopes: ["source.ferret", "meta.function.ferret", "storage.type.sub.ferret"]
      expect(lines[0][11]).toEqual value: "{", scopes: ["source.ferret"]
      expect(lines[2][0]).toEqual value: "}};", scopes: ["source.ferret"]

  describe "tokenizes format", ->
    it "works as expected", ->
      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                     Passwd File
Name                Login    Office   Uid   Gid Home
------------------------------------------------------------------
.
format STDOUT =
@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<
$name,              $login,  $office,$uid,$gid, $home
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.ferret", "meta.format.ferret", "support.function.ferret"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.ferret", "meta.format.ferret", "entity.name.function.format.ferret"]
      expect(lines[1][0]).toEqual value: "Passwd File", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[2][0]).toEqual value: "Name                Login    Office   Uid   Gid Home", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[3][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[4][0]).toEqual value: ".", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[5][0]).toEqual value: "format", scopes: ["source.ferret", "meta.format.ferret", "support.function.ferret"]
      expect(lines[5][2]).toEqual value: "STDOUT", scopes: ["source.ferret", "meta.format.ferret", "entity.name.function.format.ferret"]
      expect(lines[6][0]).toEqual value: "@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[8][0]).toEqual value: ".", scopes: ["source.ferret", "meta.format.ferret"]

      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                         Bug Reports
@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>
$system,                      $%,         $date
------------------------------------------------------------------
.
format STDOUT =
Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      $subject
Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    $index,                       $description
Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
       $priority,        $date,   $description
From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   $from,                         $description
Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          $programmer,            $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...
                                  $description
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.ferret", "meta.format.ferret", "support.function.ferret"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.ferret", "meta.format.ferret", "entity.name.function.format.ferret"]
      expect(lines[2][0]).toEqual value: "@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[4][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[5][0]).toEqual value: ".", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[6][0]).toEqual value: "format", scopes: ["source.ferret", "meta.format.ferret", "support.function.ferret"]
      expect(lines[6][2]).toEqual value: "STDOUT", scopes: ["source.ferret", "meta.format.ferret", "entity.name.function.format.ferret"]
      expect(lines[7][0]).toEqual value: "Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[9][0]).toEqual value: "Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[11][0]).toEqual value: "Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[13][0]).toEqual value: "From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[15][0]).toEqual value: "Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[17][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[19][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[21][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[23][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[25][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...", scopes: ["source.ferret", "meta.format.ferret"]
      expect(lines[27][0]).toEqual value: ".", scopes: ["source.ferret", "meta.format.ferret"]

  describe "when a heredoc tokenizes", ->
    it "does not highlight the whole line", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<TEST, $bar, s/foo/bar/g);
asd
TEST
;""")
      expect(lines[0][4]).toEqual value: "<<", scopes: ["source.ferret", "punctuation.definition.string.ferret", "string.unquoted.heredoc.ferret", "punctuation.definition.heredoc.ferret"]
      expect(lines[0][5]).toEqual value: "TEST", scopes: ["source.ferret", "punctuation.definition.string.ferret", "string.unquoted.heredoc.ferret"]
      expect(lines[0][6]).toEqual value: ", ", scopes: ["source.ferret"]
      expect(lines[3][0]).toEqual value: ";", scopes: ["source.ferret"]

    it "does not highlight variables and escape sequences in a single quote heredoc", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<'TEST');
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.ferret", "string.unquoted.heredoc.quote.ferret"]

      lines = grammar.tokenizeLines("""$asd->foo(<<\\TEST);
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.ferret", "string.unquoted.heredoc.quote.ferret"]

  describe "when a hash variable tokenizes", ->
    it "does not highlight whitespace beside a key as a constant", ->
      lines = grammar.tokenizeLines("""my %hash = (
  key => 'value1',
  'key' => 'value2'
);""")
      expect(lines[1][0]).toEqual value: "key", scopes: ["source.ferret", "constant.other.key.ferret"]
      expect(lines[1][1]).toEqual value: " ", scopes: ["source.ferret"]
      expect(lines[2][0]).toEqual value: "'", scopes: ["source.ferret", "string.quoted.single.ferret", "punctuation.definition.string.begin.ferret"]
      expect(lines[2][1]).toEqual value: "key", scopes: ["source.ferret", "string.quoted.single.ferret"]
      expect(lines[2][2]).toEqual value: "'", scopes: ["source.ferret", "string.quoted.single.ferret", "punctuation.definition.string.end.ferret"]
      expect(lines[2][3]).toEqual value: " ", scopes: ["source.ferret"]

  describe "when package to tokenizes", ->
    it "does not highlight semicolon in package name", ->
      {tokens} = grammar.tokenizeLine("package Test::ASD; #this is my new class")
      expect(tokens[0]).toEqual value: "package", scopes: ["source.ferret", "meta.class.ferret", "keyword.control.ferret"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.ferret", "meta.class.ferret"]
      expect(tokens[2]).toEqual value: "Test::ASD", scopes: ["source.ferret", "meta.class.ferret", "entity.name.type.class.ferret"]
      expect(tokens[3]).toEqual value: "; ", scopes: ["source.ferret"]
      expect(tokens[4]).toEqual value: "#", scopes: ["source.ferret", "comment.line.number-sign.ferret", "punctuation.definition.comment.ferret"]
      expect(tokens[5]).toEqual value: "this is my new class", scopes: ["source.ferret", "comment.line.number-sign.ferret"]
