module tests::PsacTester

//import solver::Z3;
import solver::SolverRunner;
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
import lang::smtlib25::response::Syntax;

str getNameFromResponse(Expr e) = "<e.constructor>" when e is cons;
str getNameFromResponse(Expr e) = "<e.varName>" when e is var;

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
    
    list[tuple[str,str]] incompatibleEvents = [];
    
    while(sat) {
      println("Next model:");
      model = getModel(z3, ["state_before", "e1", "state_post_e1", "e2", "accepts_e2"]);
      //println(model);
      
      // negate found model
      e1 = getValue(z3, "e1");
      e2 = getValue(z3, "e2");
      
      incompatibleEvents += <getNameFromResponse(e1), getNameFromResponse(e2)>;
      
      asserts = "(assert (not (and (is-<getNameFromResponse(e1)> e1) (is-<getNameFromResponse(e2)> e2))))";
      ;assertE2 = "(assert ))";
      println("Asserting: <asserts>");
      
      runSolver(z3, asserts);
      
      // continue
      sat = checkSat(z3);
    }
     
    println("<intercalate("\n", incompatibleEvents)>");
  } catch ex: throw (ex);
  finally {
    stopSolver(z3);
  }
  return true;
}