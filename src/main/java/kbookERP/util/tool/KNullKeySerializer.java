package kbookERP.util.tool;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import org.codehaus.jackson.JsonProcessingException;

import java.io.IOException;

public class KNullKeySerializer extends StdSerializer<Object> {
    public KNullKeySerializer() {
        this(null);
    }

    public KNullKeySerializer(Class<Object> t) {
        super(t);
    }

    @Override
    public void serialize(Object nullKey, JsonGenerator jsonGenerator, SerializerProvider unused)
            throws IOException, JsonProcessingException {
        jsonGenerator.writeFieldName("");
    }
}
