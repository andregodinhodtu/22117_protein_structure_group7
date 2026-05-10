# Copyright (C) 2024 Lorenzo Favaro

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import argparse

# Paths to the input files
clust_size_path = 'clust_size.xvg'
clust_id_path = 'clust_id.xvg'
rmsd_path = 'rmsd_concat.xvg'

# Function to clean and extract the actual data from .xvg files (ignoring metadata lines starting with # or @)
def extract_data(content):
    data = []
    for line in content:
        # Ignore metadata lines starting with '#' or '@'
        if not line.startswith('#') and not line.startswith('@'):
            data.append(line.strip())
    return data

# Parse command-line arguments
parser = argparse.ArgumentParser(description='Plot cluster analysis results.')
parser.add_argument('-n', type=int, default=5, help='Number of top clusters to visualize in the heatmap')
args = parser.parse_args()

# Read and clean cluster size data
with open(clust_size_path, 'r') as file:
    clust_size_content = file.readlines()
clust_size_data = extract_data(clust_size_content)

# Read and clean cluster ID data
with open(clust_id_path, 'r') as file:
    clust_id_content = file.readlines()
clust_id_data = extract_data(clust_id_content)

# Read and clean RMSD data
with open(rmsd_path, 'r') as file:
    rmsd_content = file.readlines()
rmsd_data = extract_data(rmsd_content)

# Parsing cluster size data
cluster_ids, cluster_sizes = zip(*[map(int, line.split()) for line in clust_size_data])

# Plotting histogram of cluster sizes
plt.figure(figsize=(10, 6))
plt.bar(cluster_ids, cluster_sizes, color='blue', alpha=0.7, align='center', width=0.8)
plt.xlabel('Cluster ID')
plt.xticks(ticks=np.arange(len(cluster_ids)) + 1, labels=[int(i) for i in cluster_ids], ha='center')
plt.xlim(left=0.5)
plt.ylabel('Number of Frames')
plt.title('Distribution of Frames Across Clusters')
plt.grid(axis='y', linestyle='--', alpha=0.6)
plt.savefig('cluster_size_histogram.png')

# Parsing cluster population time series data with float values
time_points, cluster_assignments = zip(*[map(float, line.split()) for line in clust_id_data])

# Convert time points and cluster assignments to a DataFrame for easier manipulation
df = pd.DataFrame({'Time (ps)': time_points, 'Cluster ID': cluster_assignments})

top_n = args.n
# Get the top N clusters based on the number of occurrences
top_clusters = df['Cluster ID'].value_counts().nlargest(top_n).index
filtered_df = df[df['Cluster ID'].isin(top_clusters)]

# Pivot table for heatmap data
heatmap_data = filtered_df.pivot_table(index='Cluster ID', columns='Time (ps)', aggfunc='size', fill_value=0)

# Plot heatmap
plt.figure(figsize=(16, 8))
sns.heatmap(heatmap_data, cmap='viridis', cbar=False)
plt.xlim(left=1)
plt.xlabel('Time (ps)')
plt.xticks(np.linspace(0, heatmap_data.shape[1] - 1, num=6, dtype=int), labels=np.linspace(0, 1000000, num=6, dtype=int), rotation=45)


plt.ylabel('Cluster ID', labelpad=20, rotation=0, ha='center')
plt.yticks(ticks=np.arange(len(heatmap_data.index)) + 0.5, labels=[int(i) for i in heatmap_data.index], va='center')
plt.yticks(np.arange(len(heatmap_data.index)) + 0.5, labels=[int(i) for i in heatmap_data.index], va='center')
plt.title(f'Heatmap of Top {top_n} Cluster Occupancy Over Time')
plt.savefig(f'cluster_population_heatmap_top_{top_n}.png')

# Parsing RMSD data (assuming two columns: time and RMSD value)
rmsd_time, rmsd_values = zip(*[map(float, line.split()) for line in rmsd_data])

# Plotting RMSD vs. Time
plt.figure(figsize=(10, 6))
plt.plot(rmsd_time, rmsd_values, color='purple', alpha=0.7)
plt.xlabel('Time (ps)')
plt.ylabel('RMSD (nm)')
plt.title('RMSD Over Time')
plt.grid(axis='both', linestyle='--', alpha=0.5)
plt.savefig('rmsd_vs_time.png')
