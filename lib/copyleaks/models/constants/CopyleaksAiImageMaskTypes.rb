module Copyleaks
  # Values of maskType for AI image detection.
  class CopyleaksAiImageMaskTypes
    # Run-length encoded mask of the regions flagged as AI-generated (server default).
    BINARY = "binary"
    # Like BINARY, plus result.labels: one confidence band (0-4) per segment.
    HEATMAP = "heatmap"
    # No mask: the response has no result object. Synchronous check only.
    NONE = "none"
  end
end
