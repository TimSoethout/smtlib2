module tests::PsacTester

//import \solve::Z3;
import \solve::SolverRunner;
import IO;

import Parser;
import Imploder;
import ParseTree;
import lang::AST;
import Resolver;
import Parser;
import Checker;
//import Imploder;
import lang::smtlib25::Syntax;

bool state() {
  int z3 = startSolver();
  try {
    println(z3);
    
    Script script = parseSmt2(|file:///Users/tim/workspace/tim-phd/papers/notes/account.psac.state.smt2|).top;
    println(script);
    
    Refs refs = resolve(script);
    //println(refs);
    
    checks = check(script, refs);
    
    println(checks);
    
    result = runSolver(z3,  "<script>", debug = true);
    //result = isSatisfiable(z3, "<script>");
    
    bool sat = checkSat(z3);
    
    println("check-sat: <sat>");
    println(getSolvingTime(z3));
    
    
    while(sat) {
      model = getModel(z3, ["state_before", "e1", "state_post_e1", "e2", "accepts_e2"]);
      println(model);
      
      // negate found model
      e1 = getValue(z3, "e1");
      e2 = getValue(z3, "e1");
      
      // continue
      sat = checkSat(z3);
    }
     
    println("<result>");
  } catch ex: throw (ex);
  finally {
    stopSolver(z3);
  }
  return true;
}