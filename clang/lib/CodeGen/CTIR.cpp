//===--- CTIR.cpp - Helpers for setting high-level deref. metadata -----===//

#include "CTIR.h"

using namespace clang;
using namespace CodeGen;

const std::string CTIR::MDName = "ctir";
const std::string CTIR::VTMDName = "ctir.vt";
const std::string CTIR::VTInitMDName = "ctir.vt.init";

CGDebugInfo *CTIR::DI = nullptr;

void CTIR::setMetadata(llvm::Value *V, QualType T, std::string MD) {
  // Are we emitting or not?
  if (DI == nullptr) return;
  assert("CTIR::setMetadata: given a null Value!");

  llvm::DIType *DIType = DI->getOrCreateStandaloneType(T, SourceLocation());
  if (llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(V)) {
    I->setMetadata(MD, DIType);
  } else if (llvm::GlobalObject *GO = llvm::dyn_cast<llvm::GlobalObject>(V)) {
    GO->setMetadata(MD, DIType);
  } else if (llvm::isa<llvm::Constant>(V)) {
    // ctir-TODO: cleaner handling.
    llvm::errs() << "CTIR: given a Constant.\n";
  } else {
    assert(false && "CTIR: not given instruction/global object?");
  }
}

void CTIR::enable(CGDebugInfo *DI) {
  CTIR::DI = DI;
}

void CTIR::finish(bool DIFinalize) {
  if (DIFinalize) {
    DI->finalize();
  }

  DI = nullptr;
}

