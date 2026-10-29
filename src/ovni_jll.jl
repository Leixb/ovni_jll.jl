# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule ovni_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("ovni")
JLLWrappers.@generate_main_file("ovni", Base.UUID("70e23989-2122-5d0d-a43e-e59276770a20"))
end  # module ovni_jll
