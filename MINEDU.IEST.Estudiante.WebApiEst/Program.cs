using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Inf_Apis.Extension;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;
using MINEDU.IEST.Estudiante.Manager.MappingDto;
using Newtonsoft.Json.Serialization;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var configuration = builder.Configuration;
BackEndConfig backEndConfig = configuration.GetSection("BackEndConfig").Get<BackEndConfig>();

//Seri Log - Config
builder.Host.UseSerilog((ctx, lc) => lc
    .WriteTo.Console()
    .ReadFrom.Configuration(ctx.Configuration.GetSection("Logging")));

//Automapper

builder.Services.AddAutoMapper(typeof(AutoMapperHelper));


//EF Core
builder.Services.Configure<BackEndConfig>(configuration.GetSection("BackEndConfig"));
builder.Services.AddDbContext<estudianteContext>(
    opt => opt.UseSqlServer(backEndConfig.BdSqlServer));

//Inyeccion de Dependencia.
builder.Services.InyectaDependencias();

//Inyectando CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy(backEndConfig.NombrePoliticaCors, b =>
    {
        b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

//Auto Mapper
builder.Services.AddAutoMapper(typeof(AutoMapperHelper));

// Config Swagger
builder.Services.AddSwaggerGen(opt =>
{
    opt.SwaggerDoc("v1", new OpenApiInfo { Title = "Web Api para Estudiantes", Version = "v1" });
});
//builder.Services.AddEndpointsApiExplorer();
builder.Services.AddControllers()
    .AddNewtonsoftJson(options =>
    {
        options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        options.SerializerSettings.ContractResolver = new DefaultContractResolver();
    });



// Configure the HTTP request pipeline.
var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("../swagger/v1/swagger.json", "Web Api para Estudiantes v1"));
}

app.UseSerilogRequestLogging();
app.UseCors(backEndConfig.NombrePoliticaCors);

app.UseAuthorization();

app.MapControllers();

app.Run();
