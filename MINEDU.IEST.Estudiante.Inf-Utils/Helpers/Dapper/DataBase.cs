using Dapper;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.Dapper
{
    public class DataBase : IDapper
    {
        private readonly IConfiguration _config;
        private string Connectionstring = "BackEndConfig:BdSqlServer";
        public DataBase(IConfiguration config)
        {
            _config = config;
        }
        public int Execute(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure)
        {
            int result;
            using (IDbConnection db = new SqlConnection(_config.GetSection(Connectionstring).Value))
            {
                try
                {
                    if (db.State == ConnectionState.Closed)
                    {
                        db.Open();
                    }

                    using (IDbTransaction tran = db.BeginTransaction())
                    {
                        try
                        {
                            result = db.Execute(sql, commandType: commandType, transaction: tran);
                            tran.Commit();
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            throw ex;
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (db.State == ConnectionState.Open)
                    {
                        db.Close();
                    }
                }
            }

            return result;
        }

        public T Get<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure)
        {
            using (IDbConnection db = new SqlConnection(_config.GetSection(Connectionstring).Value))
            {
                return db.Query<T>(sql, commandType: commandType).FirstOrDefault();
            }
        }

        public async Task<List<T>> GetAll<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure)
        {
            using (IDbConnection db = new SqlConnection(_config.GetSection(Connectionstring).Value))
            {
                List<T> ts = db.QueryAsync<T>(sql, param, commandType: commandType).Result.ToList();
                return ts;
            }
        }

        public DbConnection GetDbConnection()
        {
            return new SqlConnection(_config.GetSection(Connectionstring).Value);
        }

        public T Insert<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure)
        {
            T result;
            using (IDbConnection db = new SqlConnection(_config.GetSection(Connectionstring).Value))
            {
                try
                {
                    if (db.State == ConnectionState.Closed)
                    {
                        db.Open();
                    }

                    using (IDbTransaction tran = db.BeginTransaction())
                    {
                        try
                        {
                            result = db.Query<T>(sql, commandType: commandType, transaction: tran).FirstOrDefault();
                            tran.Commit();
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            throw ex;
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (db.State == ConnectionState.Open)
                    {
                        db.Close();
                    }
                }
            }

            return result;
        }

        public T Update<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure)
        {
            T result;
            using (IDbConnection db = new SqlConnection(_config.GetSection(Connectionstring).Value))
            {
                try
                {
                    if (db.State == ConnectionState.Closed)
                    {
                        db.Open();
                    }

                    using (IDbTransaction tran = db.BeginTransaction())
                    {
                        try
                        {
                            result = db.Query<T>(sql, commandType: commandType, transaction: tran).FirstOrDefault();
                            tran.Commit();
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            throw ex;
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (db.State == ConnectionState.Open)
                    {
                        db.Close();
                    }
                }
            }

            return result;
        }
    }
}
