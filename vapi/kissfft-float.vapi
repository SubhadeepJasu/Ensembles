/*
  Copyright (C) 2012 Davorin Šego

  Permission is hereby granted, free of charge, to any person obtaining a copy of
  this software and associated documentation files (the "Software"), to deal in
  the Software without restriction, including without limitation the rights to
  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
  of the Software, and to permit persons to whom the Software is furnished to do
  so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/

[CCode (cprefix = "kiss_fft_", lower_case_cprefix = "kiss_fft_", cheader_filename = "kiss_fft.h")]
namespace KissFFT {

  [SimpleType]
  public struct scalar : float {}

  [CCode (cname = "kiss_fft_cpx")]
  public struct Cpx {
    scalar r;
    scalar i;
  }

  [SimpleType]
  [CCode (cname = "kiss_fft_cfg", destroy_function = "kiss_fft_free")]
  public struct Cfg {}

  public Cfg alloc(int nfft, bool inverse_fft, void* mem, size_t* lenmem);

  [CCode (cname = "kiss_fft")]
  public void transform(Cfg cfg, Cpx* fin, Cpx* fout);

  [CCode (cname = "kiss_fft_stride")]
  public void transform_stride(Cfg cfg, Cpx* fin, Cpx* fout, int fin_stride);

  public void cleanup();
  public int next_fast_size(int n);
//  public int kiss_fftr_next_fast_size_real(n)

}

[CCode (cprefix = "kiss_fftr_", lower_case_cprefix = "kiss_fftr_", cheader_filename = "tools/kiss_fftr.h")]
namespace KissFFTR {

  [SimpleType]
  [CCode (cname = "kiss_fftr_cfg", destroy_function = "kiss_fftr_free")]
  public struct Cfg {}

  public Cfg alloc(int nfft, bool inverse_fft, void* mem, size_t* lenmem);

  [CCode (cname = "kiss_fftr")]
  public void transform(Cfg cfg, KissFFT.scalar* timedata, KissFFT.Cpx* freqdata);
  [CCode (cname = "kiss_fftri")]
  public void transform_inverse(Cfg cfg, KissFFT.Cpx* freqdata, KissFFT.scalar* timedata);

}
