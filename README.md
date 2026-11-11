# PLUE
# MATLAB Code for Cropland Vegetation Dynamics in the Tumen River Basin

## Overview

This repository provides the MATLAB script used for data analysis and figure generation in the study:

**"Long-term satellite observations reveal cross-border disparities in cropland vegetation dynamics: disentangling the effects of climate and land management"**

The study investigates long-term cropland vegetation dynamics in the transboundary Tumen River Basin between China and the Democratic People's Republic of Korea (DPRK), with a focus on the potential effects of climate change and land management.

## Code Description

The repository contains the following MATLAB script:

- `redraw_figures_2_to_8.m`: MATLAB script for data analysis and generation of Figures 2–8 in the manuscript.

The script covers the following analyses:

- Seasonal and interannual variations in precipitation and temperature.
- Long-term spatial patterns and trends in leaf area index (LAI).
- Comparisons of cropland vegetation dynamics between the Chinese and DPRK sides.
- Paired Land Use Experiment (PLUE) analysis.
- Residual trend analysis and the assessment of climate-related and human-activity-related contributions.
- Spatial analysis of nitrogen inputs and irrigation patterns.

## Requirements

- MATLAB R2023b or later.
- MATLAB Mapping Toolbox and other required toolboxes.
- Auxiliary MATLAB functions used for data processing, statistical analysis, and visualization.

## Data Requirements

The script uses multiple input datasets, including:

- MODIS LAI data.
- Climate data from TerraClimate.
- Land-cover and cropland mask data.
- Nitrogen input datasets.
- Irrigation extent data.
- Geographic boundary and study-area files.

The original datasets and auxiliary files are not included in this repository. Users should obtain the required datasets from their respective providers and configure the corresponding file paths before running the script.
