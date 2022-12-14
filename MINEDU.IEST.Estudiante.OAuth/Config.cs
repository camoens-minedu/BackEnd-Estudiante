// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.


using IdentityModel;
using IdentityServer4;
using IdentityServer4.Models;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using System.Collections.Generic;
using System.Security.Claims;

namespace MINEDU.IEST.Estudiante.OAuth
{
    public static class Config
    {

        public static string urlServerWeb => Startup.StaticConfig.GetSection("urlAppEstudiante:urlServerWeb").Value.ToString();
        public static string urlBase => Startup.StaticConfig.GetSection("urlAppEstudiante:urlBase").Value.ToString();

        public static IEnumerable<IdentityResource> IdentityResources =>
                   new IdentityResource[]
                   {
                       new IdentityResources.OpenId(),
                       new IdentityResources.Profile(),
                       new IdentityResources.Email(),
                       new IdentityResource
                       {
                           Name = "Sistema-Gestion-Estdiantes-Recursos",
                           DisplayName = "Web.Api.SisCat OIDC Profile",
                           Description = "Recurso Perfil que contiene los roles y permisos",
                           Enabled = true,
                           UserClaims = { SecurityClaimType.GrantAccess, ClaimTypes.Role, JwtClaimTypes.Role, JwtClaimTypes.Name}
                       }
                   };

        public static IEnumerable<ApiScope> ApiScopes =>
            new ApiScope[]
            {
                new ApiScope("scope1"),
                new ApiScope("scope2"),
                new ApiScope("MINEDU.IEST.Estudiante.WebApiEst"),
                new ApiScope("MINEDU.IEST.Estudiante.OAuth.Api"),

            };


        public static IEnumerable<ApiResource> ApiResources =>
          new ApiResource[]{
                new ApiResource
                {
                    Name="MINEDU.IEST.Estudiante.WebApiEst",
                    DisplayName = "MINEDU.IEST.Estudiante.WebApiEst OIC Estudiante API",
                    Scopes = { "MINEDU.IEST.Estudiante.WebApiEst" },
                    UserClaims = { SecurityClaimType.GrantAccess,ClaimTypes.Role, JwtClaimTypes.Role, JwtClaimTypes.Name },
                    ApiSecrets = { new Secret{Value = "o90IbCACXKUkunXoa18cODcLKnQTbjOo5ihEw9j58+8=" } }
                },
              new ApiResource
                {
                    Name="MINEDU.IEST.Estudiante.OAuth.Api",
                    DisplayName = "MINEDU.IEST.Estudiante.OAuth.Api OIC SEGURIDAD para Estudiante API",
                    Scopes = { "MINEDU.IEST.Estudiante.WebApiEst" },
                    UserClaims = { SecurityClaimType.GrantAccess,ClaimTypes.Role, JwtClaimTypes.Role, JwtClaimTypes.Name },
                    ApiSecrets = { new Secret{Value = "o90IbCACXKUkunXoa18cODcLKnQTbjOo5ihEw9j58+8=" } }
                }

          };


        public static IEnumerable<Client> Clients =>
            new Client[]
            {
                // m2m client credentials flow client
                new Client
                {
                    ClientId = "cliente-demo",
                    ClientName = "Client Credentials Client - Demo Genera Token",

                    AllowedGrantTypes = GrantTypes.ClientCredentials,
                    ClientSecrets = { new Secret("511536EF-F270-4058-80CA-1C89C192F69A".Sha256()) },
                    AllowedScopes =
                    {
                        "scope1",
                        "MINEDU.IEST.Estudiante.WebApiEst",
                        "MINEDU.IEST.Estudiante.OAuth.Api"
                    }
                },

                // interactive client using code flow + pkce
                new Client
                {
                    ClientId = "interactive",
                    ClientSecrets = { new Secret("49C1A7E1-0C79-4A89-A3D6-A37998FB86B0".Sha256()) },

                    AllowedGrantTypes = GrantTypes.Code,

                    RedirectUris = { "https://localhost:44300/signin-oidc" },
                    FrontChannelLogoutUri = "https://localhost:44300/signout-oidc",
                    PostLogoutRedirectUris = { "https://localhost:44300/signout-callback-oidc" },

                    AllowOfflineAccess = true,
                    AllowedScopes = { "openid", "profile", "scope2" }
                },
                new Client
                {
                    ClientName = "Sistema de Gestión para Estudiantes",
                    ClientId = "angular-app-estudiante",
                    AllowedGrantTypes = GrantTypes.Code,
                    RedirectUris = new List<string>{ $"{urlBase}/signin-callback", $"{urlBase}/assets/silent-callback.html" },
                    RequirePkce = true,
                    AllowAccessTokensViaBrowser = true,
                    AllowedScopes =
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        "MINEDU.IEST.Estudiante.WebApiEst",
                        "MINEDU.IEST.Estudiante.OAuth.Api"
                    },
                    AllowedCorsOrigins = { $"{urlServerWeb}" },
                    RequireClientSecret = false,
                    PostLogoutRedirectUris = new List<string> { $"{urlBase}/signout-callback" },
                    RequireConsent = false,
                    AccessTokenLifetime = 3600
                }
            };
    }
}