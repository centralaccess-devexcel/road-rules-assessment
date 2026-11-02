using Microsoft.EntityFrameworkCore;
using RoadRules.Data;

namespace RoadRules.Services;

public class EfLimitSource(IDbContextFactory<AppDbContext> factory) : ILimitSource
{
    public async Task<IReadOnlyList<LimitRecord>> GetLimitsAsync(string jurisdictionCode)
    {
        await using var db = await factory.CreateDbContextAsync();
        return await db.AxleLimits
            .Where(l => l.Jurisdiction!.Code == jurisdictionCode)
            .OrderBy(l => l.AxleCount).ThenBy(l => l.Id) // ThenBy: ties have no defined order on SQL Server
            .Select(l => new LimitRecord(l.AxleGroup, l.AxleCount, l.MaxKg))
            .ToListAsync();
    }
}
