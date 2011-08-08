# Holt-Winters Triple Exponential Smoothing Algorithm

This is a Ruby port of Nishant Chandra's [Java implementation](http://n-chandra.blogspot.com/2011/04/holt-winters-triple-exponential.html).

# Usage

This will generate a several variations of beta for a simple line.

Try plotting the different lines to see how beta affects the forecast.

    require 'holt_winters'
    
    x = (0..128).to_a
    puts x.join(',')
    puts HoltWinters.forecast(x, 0.5, 0, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.25, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.5, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.75, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 1.0, 0, 12, 2).join(',')


# License

(The MIT-License)

Copyright (c) 2011 Brandon Keene

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
