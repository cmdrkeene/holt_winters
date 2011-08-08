# Holt-Winters Triple Exponential Smoothing Algorithm

A Ruby port of Nishant Chandra's 
[Java implementation](http://n-chandra.blogspot.com/2011/04/holt-winters-triple-exponential.html) 
of the Holt-Winters smoothing algorithm.

![Algorithm](http://www.itl.nist.gov/div898/handbook/pmc/section4/eqns/ts26.gif)

    The equations are intended to give more weight to recent observations and less weights to observations further in the past.
    These weights are geometrically decreasing by a constant ratio.
    
# Usage

## forecast()

It calculates the initial values and returns the forecast for __m__ periods.

    # y           Time series array
    # alpha       Level smoothing coefficient
    # beta        Trend smoothing coefficient (increasing beta tightens fit)
    # gamma       Seasonal smoothing coefficient
    # period      A complete season's data consists of L periods. And we need
    #             to estimate the trend factor from one period to the next. To
    #             accomplish this, it is advisable to use two complete seasons;
    #             that is, 2L periods.  
    # m           Extrapolated future data points
    #             - 4 quarterly
    #             - 7 weekly
    #             - 12 monthly
    def forecast(y, alpha, beta, gamma, period, m)
      # ...
    end


## Example

This will generate a several variations of beta for a simple line:

    require 'holt_winters'
    
    x = (0..128).to_a
    puts x.join(',')
    puts HoltWinters.forecast(x, 0.5, 0, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.25, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.5, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 0.75, 0, 12, 2).join(',')
    puts HoltWinters.forecast(x, 0.5, 1.0, 0, 12, 2).join(',')

Try plotting the different lines to see how beta affects the forecast:

![Chart](http://www.itl.nist.gov/div898/handbook/pmc/section4/gifs/tseries6.gif)

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
