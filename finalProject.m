<?xml version="1.0" encoding="UTF-8"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:pPr><w:pStyle w:val="title"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Text Mining with MATLAB</w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part 1</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[clear;
% Adapted from https://blogs.mathworks.com/loren/2015/09/09/text-mining-shakespeare-with-matlab/
lyrics = fileread('leonard-cohen.txt')           % read file content
%disp(lyrics(662:866))                           % preview the text
]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Processing </w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[    min_length = 1;

% split text into larger sections - let's call them |paragraphs|
paragraphs = regexp(lyrics, '\r\n\r\n', 'split');  % split double line breaks

% split |paragraphs| into sentences
sentences = regexp(paragraphs, '\n', 'split');              % split by punctuations
%sentences = regexp(sentences)

sentences = [sentences{:}]';                    % flatten the cell array
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells

%% Dealing with exceptions: We have some remaining issues. 
sentences = regexp(sentences, '--', 'split');   % split by double hyphens
sentences = [sentences{:}]';                    % flatten the cell array
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells
sentences = regexprep(sentences, '^\n\r', '');  % remove LFCR
sentences = regexprep(sentences, '^\r\n', '');  % remove CRLF
sentences = regexprep(sentences, '^\n', '');    % remove LF
sentences = regexprep(sentences, '^\r', '');    % remove CR
sentences = regexprep(sentences, '^:', '');     % remove colon
sentences = regexprep(sentences, '^\.', '');    % remove period
sentences = regexprep(sentences, '^\s', '');    % remove space
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells

%% Remove short sentences: If a sentence is too short, then it doesn't help. 
tokens = cellfun(@strsplit, sentences,'UniformOutput', false);       % tokenize sentences

%isShort = cellfun(@length, tokens) < min_length;% shorter than minimum?
%sentences(isShort)= [];                         % remove short sentences

%% Add Sentence Markers: For further processing, we need to add <s> and </s> to mark the start and the end of sentences. 
for i = 1:length(sentences)
    sentences{i} = ['<s> ' strtrim(sentences{i}) ' </s>'];

end
delimiters = {' ', '"','!', '''', ',', '-', '.', ':', ';', '?', '\r', '\n', '--', '&'}; 
processed=lower(sentences);
words = cellfun(@(x) strsplit(x,  delimiters), processed, 'UniformOutput', false);       % split text into tokens
tokens3 =cellfun(@flip,words,'UniformOutput',false);
Reversed =cellfun(@strjoin,tokens3,'UniformOutput',false);
Allwords=[tokens{:}];
Allwords2=[tokens(:)];
Allwords3=unique(Allwords)';
]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[
Allwords4 = [Allwords2{:}]'


length(Allwords2)
length(Allwords2{1,1})
for i=1:length(Allwords2)
length2(i)=length(Allwords2{i,1});
end
mean(length2)]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Build Model</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[delimiters = {' ', '!', '''', ',', '-', '.',... % word boundary characters
    ':', ';', '?', '\r', '\n', '--', '&'};
biMdl = bigramClass(delimiters);                % Build bigram model
biMdl.build(processed);    ]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Run Model</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[%rng(2)                              % for reproducibility
[lyric end_word]=textGen(biMdl)    % generate random text
                                    % Also pull last word for section B
]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part e)</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[P=biMdl.mdl
out=sum(P,2)
C=67;                   % 67 is column corresponding with end: '</s>'
B=setdiff(1:2495,C) ;               
PBB=P(B,B)                % remove column
sum(PBB,2)
det(eye(2494)-PBB)                  % check if invertible
vB=(eye(2494)-PBB)\ones(2494,1)        % solve linear equation

 ]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Re-run as Trigram</w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[triMdl = trigramClass(delimiters);              % generate trigrams
triMdl.build(processed, biMdl);                 % build a trigram model
rng(2)                                          % for reproducibility
textGen(triMdl)  

P=triMdl.mdl
]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[T=triMdl.mdl
out=sum(T,2)
n=0
for i=1:9306
if out(i)==0
    n=n+1;
end
end
n
C=67;                   % 67 is column corresponding with end: '</s>'
B=setdiff(1:2495,C)                
TBB=T(B,B)                      % remove column
det(eye(2494)-TBB)                  % check if invertible
vB=(eye(2494)-TBB)\ones(2494,1)        % solve linear equation

 ]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part 2 B</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[words = cellfun(@(x) strsplit(x,  delimiters), processed, 'UniformOutput', false);       % split text into tokens
tokens3 =cellfun(@flip,words,'UniformOutput',false);      % mirror flip words within a sentences 
Reversed =cellfun(@strjoin,tokens3,'UniformOutput',false);  % re-assemble as flipped sentence
delimiters = {' ', '!', '''', ',', '-', '.',... % word boundary characters
    ':', ';', '?', '\r', '\n', '--', '&', '`', ')','('};
biMdl2 = bigramClass(delimiters);   
biMdl2.build(Reversed);                      % Build bigram model reading text in reverse
lyric2=textGen(biMdl2, end_word);                 % Generate Text from reversed model
tokens4 = cellfun(@(x) strsplit(x,  delimiters), lyric2, 'UniformOutput', false);      % Unreverse text 
tokens4 =cellfun(@flip,tokens4,'UniformOutput',false);                                  % Unreverse text 
UnReversed =cellfun(@strjoin,tokens4,'UniformOutput',false)                                % Unreverse text 
]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part 2 D</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[[lyric end_word]=textGen(biMdl) ;
lyric
n=1;
end_word =char(end_word)         ;       
last_word = rhymer(end_word,n)    ;      % find rhyming word
while sum(strcmp(Allwords3,last_word))==0 % check if rhyming word in corpus
last_word;
%    fprintf("...is not in corpus, will try again...")
n=n+1;
last_word = rhymer(end_word,n);
if strcmp('No Matches',last_word)==1        % break if no matches found
    break
end
end
%last_word
%fprintf("...is in corpus")
delimiters = {' ', '!', '''', ',', '-', '.',... % word boundary characters
    ':', ';', '?', '\r', '\n', '--', '&', '`', ')','('};
biMdl2 = bigramClass(delimiters);   
biMdl2.build(Reversed);                      % Build bigram model reading text in reverse
lyric2=textGen(biMdl2, last_word);  % Generate Text starting with rhyming word
tokens4 = cellfun(@(x) strsplit(x,  delimiters), lyric2, 'UniformOutput', false);      % Unreverse text so rhyming word is at the end
tokens4 =cellfun(@flip,tokens4,'UniformOutput',false);
UnReversed =cellfun(@strjoin,tokens4,'UniformOutput',false)]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part 3 - Syllables</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="heading"/><w:jc w:val="left"/></w:pPr><w:r><w:t>Part 3 C</w:t></w:r></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[[lyric end_word]=textGen2(biMdl);
lyric
n=1;
end_word =char(end_word) ;               % flatten end_word
last_word = rhymer(end_word,n) ;         % find rhyming word
while sum(strcmp(Allwords3,last_word))==0
last_word;
   % fprintf("...is not in corpus, will try again...")
n=n+1;
last_word = rhymer(end_word,n);
if strcmp('No Matches',last_word)==1
    break
end
end
last_word;
%fprintf("...is in corpus")
[lyric3 last_word3 SylSum]=textGen2(biMdl2, last_word);
tokens5 = cellfun(@(x) strsplit(x,  delimiters), lyric3, 'UniformOutput', false);      % Unreverse text so rhyming word is at the end
tokens5 =cellfun(@flip,tokens5,'UniformOutput',false);
UnReversed2 =cellfun(@strjoin,tokens5,'UniformOutput',false)]]></w:t></w:r></w:p><w:p><w:pPr><w:sectPr/></w:pPr></w:p><w:p><w:pPr><w:pStyle w:val="code"/></w:pPr><w:r><w:t><![CDATA[

]]></w:t></w:r></w:p></w:body></w:document>
