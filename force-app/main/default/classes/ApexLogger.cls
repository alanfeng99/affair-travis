global class ApexLogger {

    public Enum TYPE_LOG {
        DEBUG,
        ERROR,
        INFO
    }

    global static String getClassName(String trace) {
        if (trace.startsWith('Class.'))
            trace = trace.substringAfter('Class.');
        return trace.substringBefore(':').substringBeforeLast('.');
    }

    global static String getMethod(String trace) {
        return trace.substringBefore(':').substringAfterLast('.');
    }

    public virtual class Log {
        public String levelLog {get; set;}
        public Date dateLog {get; set;}
        public String className {get; set;}
        public String methodName {get; set;}
        public Integer lineLog {get; set;}
        public String messageLog {get; set;}

        public void saveLog(Log logItem) {
            System.debug('logItem=' + logItem);
            ApexLog__c apexLog = new ApexLog__c();
            apexLog.LevelLog__c = logItem.levelLog;
            apexLog.DateLog__c = logItem.dateLog;
            apexLog.ClassName__c = logItem.className;
            apexLog.MethodName__c = logItem.methodName;
            apexLog.LineLog__c = logItem.lineLog;
            apexLog.MessageLog__c = logItem.messageLog;

            insert apexLog;
        }
    }

    public class ErrorLog extends Log {
        public ErrorLog (Exception ex) {
            this.levelLog = String.valueOf(ApexLogger.TYPE_LOG.ERROR);
            this.dateLog = Date.today();
            String trace = new DmlException().getStackTraceString().substringAfter('\n');
            this.className = ApexLogger.getClassName(trace);
            this.methodName = ApexLogger.getMethod(trace);
            this.lineLog = ex.getLineNumber();
            this.messageLog = ex.getMessage();
            saveLog(this);
        }
    }

    public class InfoLog extends Log {
        public InfoLog (String classNameParam, String methodNameParam, String messageLogParam) {
            this.levelLog = String.valueOf(ApexLogger.TYPE_LOG.INFO);
            this.dateLog = Date.today();
            this.className = classNameParam;
            this.methodName = methodNameParam;
            this.messageLog = messageLogParam;
            saveLog(this);
        }
    }
}