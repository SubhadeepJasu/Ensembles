[CCode(cheader_filename="lv2/lv2plug.in/ns/ext/atom/atom.h")]
namespace LV2.Atom {

    [CCode (cname = "LV2_Atom", destroy_function = "", has_type_id = false)]
    public struct Atom {
        uint32 size;
        uint32 type;
    }

    [CCode (cname = "LV2_Atom_Int", destroy_function = "", has_type_id = false)]
    public struct AtomInt {
        Atom atom;
        int32 body;
    }

    [CCode (cname = "LV2_Atom_Long", destroy_function = "", has_type_id = false)]
    public struct AtomLong {
        Atom atom;
        int64 body;
    }

    [CCode (cname = "LV2_Atom_Float", destroy_function = "", has_type_id = false)]
    public struct AtomFloat {
        Atom atom;
        float body;
    }

    [CCode (cname = "LV2_Atom_Double", destroy_function = "", has_type_id = false)]
    public struct AtomDouble {
        Atom atom;
        double body;
    }

    [SimpleType]
    [CCode (cname = "LV2_Atom_Bool", destroy_function = "", has_type_id = false)]
    public struct AtomBool : AtomInt {}

    [CCode (cname = "LV2_Atom_URID", destroy_function = "", has_type_id = false)]
    public struct AtomURID {
        Atom atom;
        uint32 body;
    }

    [CCode (cname = "LV2_Atom_String", destroy_function = "", has_type_id = false)]
    public struct AtomString {
        Atom atom;
    }

    [CCode (cname = "LV2_Atom_Literal_Body", destroy_function = "", has_type_id = false)]
    public struct AtomLiteralBody {
        uint32 datatype;
        uint32 lang;
    }

    [CCode (cname = "LV2_Atom_Literal", destroy_function = "", has_type_id = false)]
    public struct AtomLiteral {
        Atom atom;
        AtomLiteralBody body;
    }

    [CCode (cname = "LV2_Atom_Tuple", destroy_function = "", has_type_id = false)]
    public struct AtomTuple {
        Atom atom;
    }

    [CCode (cname = "LV2_Atom_Vector_Body", destroy_function = "", has_type_id = false)]
    public struct AtomVectorBody {
        uint32 child_size;
        uint32 child_type;
    }

    [CCode (cname = "LV2_Atom_Vector", destroy_function = "", has_type_id = false)]
    public struct AtomVector {
        Atom atom;
        AtomVectorBody body;
    }

    [CCode (cname = "LV2_Atom_Property_Body", destroy_function = "", has_type_id = false)]
    public struct AtomPropertyBody {
        uint32 key;
        uint32 context;
        Atom value;
    }

    [CCode (cname = "LV2_Atom_Property", destroy_function = "", has_type_id = false)]
    public struct AtomProperty {
        Atom atom;
        AtomPropertyBody body;
    }

    [CCode (cname = "LV2_Atom_Object_Body", destroy_function = "", has_type_id = false)]
    public struct AtomObjectBody {
        uint32 id;
        uint32 otype;
    }

    [CCode (cname = "LV2_Atom_Object", destroy_function = "", has_type_id = false)]
    public struct AtomObject {
        Atom atom;
        AtomObjectBody body;
    }

    [CCode (cname = "LV2_Atom_Event", destroy_function = "", has_type_id = false)]
    public struct AtomEvent {
        [CCode (cname = "time.frames")]
        int64 time_frames;
        [CCode (cname = "time.beats")]
        double time_beats;
        Atom body;
    }


    [CCode (cname = "LV2_Atom_Sequence_Body", destroy_function = "", has_type_id = false)]
    public struct AtomSequenceBody {
        uint32 unit;
        uint32 pad;
    }

    [CCode (cname = "LV2_Atom_Sequence", destroy_function = "", has_type_id = false)]
    public struct AtomSequence {
        Atom atom;
        AtomSequenceBody body;
    }

    public const string URI;

    public const string PREFIX;

    public const string _Atom;
    public const string _AtomPort;
    public const string _Blank;
    public const string _Bool;
    public const string _Chunk;
    public const string _Double;
    public const string _Event;
    public const string _Float;
    public const string _Int;
    public const string _Literal;
    public const string _Long;
    public const string _Number;
    public const string _Object;
    public const string _Path;
    public const string _Property;
    public const string _Resource;
    public const string _Sequence;
    public const string _Sound;
    public const string _String;
    public const string _Tuple;
    public const string _URI;
    public const string _URID;
    public const string _Vector;
    public const string _atomTransfer;
    public const string _beatTime;
    public const string _bufferType;
    public const string _childType;
    public const string _eventTransfer;
    public const string _frameTime;
    public const string _supports;
    public const string _timeUnit;
}
