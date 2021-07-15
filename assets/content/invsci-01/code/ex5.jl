# This file was generated, do not modify it. # hide
using PyPlot;
figure(figsize=(8, 6));
plot(df.year, df.revenue);

xlabel("Year", fontsize=14);
ylabel("Revenue", fontsize=14);

plt.savefig(joinpath(@OUTPUT, "invsci-01-time-to-harvest.svg")); # hide