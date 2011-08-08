#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/*
 * Based on th R implementation
 *
 * a: level component
 * b: trend component
 * s: seasonal component
 *
 * Additive:
 *
 *   Yhat[t+h] = a[t] + h * b[t] + s[t + 1 + (h - 1) mod p],
 *   a[t] = α (Y[t] - s[t-p]) + (1-α) (a[t-1] + b[t-1])
 *   b[t] = β (a[t] - a[t-1]) + (1-β) b[t-1]
 *   s[t] = γ (Y[t] - a[t]) + (1-γ) s[t-p]
 *
 * Multiplicative:
 *
 *   Yhat[t+h] = (a[t] + h * b[t]) * s[t + 1 + (h - 1) mod p],
 *   a[t] = α (Y[t] / s[t-p]) + (1-α) (a[t-1] + b[t-1])
 *   b[t] = β (a[t] - a[t-1]) + (1-β) b[t-1]
 *   s[t] = γ (Y[t] / a[t]) + (1-γ) s[t-p]
 */
void HoltWinters (
          double *x,
          int    *xl,           // Time t + h
          double *alpha,        // alpha parameter of Holt-Winters Filter.
          double *beta,         // beta parameter of Holt-Winters Filter. If set to 0, the function will do exponential smoothing.
          double *gamma,        // gamma parameter used for the seasonal component. If set to 0, an non-seasonal model is fitted.
          int    *start_time,   // Time t
          int    *seasonal,
          int    *period,
          double *a,            // Start value for level (a[0]).
          double *b,            // Start value for trend (b[0]).
          double *s,            // Vector of start values for the seasonal component (s_1[0] ... s_p[0])

          /* return values */
          double *SSE,          // The final sum of squared errors achieved in optimizing
          double *level,        // Estimated values for the level component (size xl - t + 1)
          double *trend,        // Estimated values for the trend component (size xl - t + 1)
          double *season        // Estimated values for the seasonal component (size xl - t + 1)
    )

{
    double res = 0, xhat = 0, stmp = 0;
    int i, i0, s0;

    /* copy start values to the beginning of the vectors */
    level[0] = *a;
    if (*beta > 0) trend[0] = *b;
    if (*gamma > 0) memcpy(season, s, *period * sizeof(double));

    for (i = *start_time - 1; i < *xl; i++) {
        /* indices for period i */
        i0 = i - *start_time + 2;
        s0 = i0 + *period - 1;

        /* forecast *for* period i */
        xhat = level[i0 - 1] + (*beta > 0 ? trend[i0 - 1] : 0);
        stmp = *gamma > 0 ? season[s0 - *period] : (*seasonal != 1);
        if (*seasonal == 1)
            xhat += stmp;
        else
            xhat *= stmp;

        /* Sum of Squared Errors */
        res   = x[i] - xhat;
        *SSE += res * res;

        /* estimate of level *in* period i */
        if (*seasonal == 1)
            level[i0] = *alpha       * (x[i] - stmp)
                      + (1 - *alpha) * (level[i0 - 1] + trend[i0 - 1]);
        else
            level[i0] = *alpha       * (x[i] / stmp)
                      + (1 - *alpha) * (level[i0 - 1] + trend[i0 - 1]);

        /* estimate of trend *in* period i */
        if (*beta > 0)
            trend[i0] = *beta        * (level[i0] - level[i0 - 1])
                      + (1 - *beta)  * trend[i0 - 1];

        /* estimate of seasonal component *in* period i */
        if (*gamma > 0) {
            if (*seasonal == 1)
                season[s0] = *gamma       * (x[i] - level[i0])
                           + (1 - *gamma) * stmp;
            else
                season[s0] = *gamma       * (x[i] / level[i0])
                       + (1 - *gamma) * stmp;
        }
    }
}

int main() {
    // US population in millions
    double series[] = {3.93, 5.31, 7.24, 9.64, 12.90, 17.10, 23.20, 31.40, 39.80, 50.20, 62.90, 76.00, 92.00, 105.70, 122.80, 131.70, 151.30, 179.30, 203.20};

    int forecast = 19;
    double alpha = 0.9999208;
    double beta = 0;
    double gamma = 0;
    int start_time = 2;
    int seasonal = 0;
    int period = 0;
    double a0 = series[0];
    double b0 = 0;
    double s[] = {};

    double errors;
    int nb_computations = forecast - start_time - 1;
    double *estimated_level = malloc(nb_computations * sizeof(double));
    double *estimated_trend = malloc(nb_computations * sizeof(double));
    double *estimated_season = malloc(nb_computations * sizeof(double));

    HoltWinters(
        series,
        &forecast,
        &alpha,
        &beta,
        &gamma,
        &start_time,
        &seasonal,
        &period,
        &a0,
        &b0,
        s,
        &errors,
        estimated_level,
        estimated_trend,
        estimated_season
    );

    int i = 0;
    int first_year = 1800;
    printf("Estimated:\n");
    for (i = 0; i < nb_computations; i++) {
        printf("\tyear = %d, level: %f, trend: %f\n", first_year + i * 10, estimated_level[i], estimated_trend[i]);
    }

    free(estimated_level);
    free(estimated_trend);
    free(estimated_season);

    return 0;
}