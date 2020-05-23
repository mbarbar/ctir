//===--- CTIR.h - Helpers for setting high-level deref. metadata --------===//

#ifndef LLVM_CLANG_LIB_CODEGEN_CDEREF_H
#define LLVM_CLANG_LIB_CODEGEN_CDEREF_H

#include "CGDebugInfo.h"

namespace clang {
namespace CodeGen {
  /// Helpers for setting high-level deref. metadata.
  /// We're using globals/statics so ctir fits into Clang as loosely as possible
  /// for easy merges.
  class CTIR {
  public:
    static const std::string MDName;
    static const std::string VTMDName;
    static const std::string VTInitMDName;

    /// Enables emission.
    static void enable(CGDebugInfo *DI);

    /// Signals to CTIR to clean up. DIFinalize indicates whether finalize
    /// should be called on DI.
    static void finish(bool DIFinalize=false);

    /// Annotates V, a GlobalObject or Instruction, with T (through DI).
    static void setMetadata(llvm::Value *V, QualType T,
                            std::string MD=MDName);

  private:
    /// DebugInfo object to emit with.
    static CGDebugInfo *DI;
  };
}  // end namespace clang
}  // end namespace CodeGen
#endif
