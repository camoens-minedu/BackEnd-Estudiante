using Dapper;
using System.Data;
using System.Data.Common;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.Dapper
{
    public interface IDapper
    {
        DbConnection GetDbConnection();

        Task<List<T>> GetAll<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure);
        T Get<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure);
        T Insert<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure);
        T Update<T>(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure);
        int Execute(string sql, DynamicParameters param, CommandType commandType = CommandType.StoredProcedure); //Delete or others

    }
}
