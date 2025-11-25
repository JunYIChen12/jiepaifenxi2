-- (V5) 极简版节拍日志表
-- 完全匹配您提供的参考代码逻辑
-- [修改] 使用 TIMESTAMP (不带时区) 来存储本地时间

-- 先删除旧表 (如果存在)，确保脚本可以重复运行
DROP TABLE IF EXISTS takt_logs;

-- 创建新表 (takt_logs)
CREATE TABLE takt_logs (
    id SERIAL PRIMARY KEY,

    -- 对应 msg.payload.stationId (例如: "ST-01")
    station_id VARCHAR(50) NOT NULL,

    -- 对应 msg.payload.stationName (例如: "B线-工序A")
    station_name VARCHAR(255),

    -- 【已修改】使用 TIMESTAMP (不带时区) 来存储本地时间
    trigger_time TIMESTAMP NOT NULL,

    -- 【已修改】使用 TIMESTAMP (不带时区) 来存储本地时间
    prev_time TIMESTAMP,

    -- 对应 interval (计算出的间隔，第一次为 NULL)
    interval_seconds DECIMAL(10, 3)
);

-- 添加中文备注
COMMENT ON TABLE takt_logs IS '节拍日志表 (V5 极简逻辑 - 本地时间)';
COMMENT ON COLUMN takt_logs.station_id IS '工位/测量点ID (例如: ST-01)';
COMMENT ON COLUMN takt_logs.station_name IS '工位/测量点名称';
COMMENT ON COLUMN takt_logs.trigger_time IS '当前信号触发时间 (本地时间)';
COMMENT ON COLUMN takt_logs.prev_time IS '上一个信号触发时间 (本地时间)';
COMMENT ON COLUMN takt_logs.interval_seconds IS '节拍间隔 (秒)';

-- 为最常见的查询创建索引
CREATE INDEX idx_station_time ON takt_logs (station_id, trigger_time DESC);
