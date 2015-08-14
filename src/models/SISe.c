/*
 *  siminf, a framework for stochastic disease spread simulations
 *  Copyright (C) 2015  Pavol Bauer
 *  Copyright (C) 2015  Stefan Engblom
 *  Copyright (C) 2015  Stefan Widgren
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Offset in compartment state vector */
enum {S, I};

/* Offset in model state vector */
enum {PHI};

/* Offsets in data to parameters in the model */
enum {UPSILON,
      GAMMA,
      ALPHA,
      BETA_Q1,
      BETA_Q2,
      BETA_Q3,
      BETA_Q4,
      EPSILON};

/**
 * susceptible to infected: S -> I
 *
 * @param u The compartment state vector in node.
 * @param v The model state vector in node.
 * @param data The data vector for node.
 * @param t Current time.
 * @param sd The sub-domain of node.
 * @return propensity.
 */
double SISe_S_to_I(
    const int *u,
    const double *v,
    const double *data,
    double t,
    int sd)
{
    return data[UPSILON] * v[PHI] * u[S];
}

/**
 *  infected to susceptible: I -> S
 *
 * @param u The compartment state vector in node.
 * @param v The model state vector in node.
 * @param data The data vector for node.
 * @param t Current time.
 * @param sd The sub-domain of node.
 * @return propensity.
 */
double SISe_I_to_S(
    const int *u,
    const double *v,
    const double *data,
    double t,
    int sd)
{
    return data[GAMMA] * u[I];
}

/**
 * Update infectious pressure
 *
 * @param u The compartment state vector in node.
 * @param v The model state vector in node.
 * @param data The data vector for node.
 * @param node The node.
 * @param t Current time.
 * @param sd The sub-domain of node.
 * @return 1 if needs update, else 0.
 */
int SISe_post_time_step(
    const int *u,
    double *v,
    const double *data,
    int node,
    double t,
    int sd)
{
    const int days_in_year = 365;
    const int days_in_quarter = 91;

    double S_n, I_n;
    double tmp = v[PHI];

    S_n = u[S];
    I_n = u[I];

    /* Time dependent beta for each quarter of the year. Forward Euler step. */
    switch (((int)t % days_in_year) / days_in_quarter) {
    case 0:
        v[PHI] *= (1.0 - data[BETA_Q1]);
        break;
    case 1:
        v[PHI] *= (1.0 - data[BETA_Q2]);
        break;
    case 2:
        v[PHI] *= (1.0 - data[BETA_Q3]);
        break;
    default:
        v[PHI] *= (1.0 - data[BETA_Q4]);
        break;
    }

    if ((I_n + S_n) > 0.0)
        v[PHI] += data[ALPHA] * I_n / (I_n + S_n) + data[EPSILON];
    else
        v[PHI] += data[EPSILON];

    /* 1 if needs update */
    return tmp != v[PHI];
}