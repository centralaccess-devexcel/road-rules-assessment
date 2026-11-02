using Microsoft.EntityFrameworkCore;
using RoadRules.Components;
using RoadRules.Data;
using RoadRules.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// A factory, not a plain AddDbContext. In Blazor Server a scoped
// DbContext would live for the whole user circuit; a factory gives each
// operation a short-lived context, which is the pattern Microsoft recommends.
builder.Services.AddDbContextFactory<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("Default")));

builder.Services.AddScoped<ILimitSource, EfLimitSource>();
builder.Services.AddScoped<IWeightCalculator, WeightCalculator>();

var app = builder.Build();

// Apply migrations on startup. Fine for a toy; in production you would
// run migrations from the pipeline, not from the app.
using (var scope = app.Services.CreateScope())
{
    var factory = scope.ServiceProvider.GetRequiredService<IDbContextFactory<AppDbContext>>();
    using var db = factory.CreateDbContext();
    db.Database.Migrate();
}

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/not-found", createScopeForStatusCodePages: true);
app.UseHttpsRedirection();

app.UseAntiforgery();

app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
