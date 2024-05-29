%{ open Syntax %}

%token EOF THE_BELIEF THE_BELIEFS HOLDS HOLD COMMA LB RB EVENTUALLY WHAT IS MAXIMUM MINIMUM PROBABILITY THAT
%left COMMA
%token <string> BEL_NAME
%start <Syntax.properties> properties
%%

properties:
    | line EOF { $1 }

line:
    | line_t line { Seq_line($1, $2) }
    | line_t { $1 }

line_t:
    | WHAT IS MINIMUM PROBABILITY THAT EVENTUALLY THE_BELIEF BEL_NAME HOLDS { Prop(Min, [|$8|]) }
    | WHAT IS MAXIMUM PROBABILITY THAT EVENTUALLY THE_BELIEF BEL_NAME HOLDS { Prop(Max, [|$8|]) }
    | WHAT IS MINIMUM PROBABILITY THAT EVENTUALLY THE_BELIEFS LB bel RB HOLD { Prop(Min, $9) }
    | WHAT IS MAXIMUM PROBABILITY THAT EVENTUALLY THE_BELIEFS LB bel RB HOLD  { Prop(Max, $9) }

bel:
    | bel COMMA bel {Array.append $1 $3}
    | BEL_NAME {Array.make 1 $1}