package broker.collision.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sneaker.types.Maybe;
import sneaker.macro.Types;
import sneaker.macro.ContextTools;
import sneaker.macro.MacroLogger.*;
import broker.collision.cell.PartitionLevel;

using haxe.macro.ExprTools;

class CollisionSpaceMacro {
	public static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();
		final localClassPathString = localClassRef.toString();

		final maybeParameters = getParameters(localClass);
		if (maybeParameters.isNone()) return null;
		final parameters = maybeParameters.unwrap();

		final widthValue: Int = parameters.width.getValue();
		final heightValue: Int = parameters.height.getValue();
		final levelValue: Int = parameters.level.getValue();
		final gridSize: Int = 1 << levelValue;
		final leafCellPositionFactorX: Float = gridSize / widthValue;
		final leafCellPositionFactorY: Float = gridSize / heightValue;

		final classDef = macro class CollisionSpace {
			/**
				The width of the entire space (i.e. the width of root cell).
			**/
			public static var width(get, never): Int;

			/**
				The height of the entire space (i.e. the height of root cell).
			**/
			public static var height(get, never): Int;

			/**
				The finest `PartitionLevel` value of `this` space (i.e. the depth of quadtrees).
			**/
			public static var partitionLevel(
				get,
				never
			): broker.collision.cell.PartitionLevel;

			/**
				The size of the space grid determined by `this.partitionLevel`.
			**/
			public static var gridSize(get, never): Int;

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static var leafCellPositionFactorX(get, never): Float;

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static var leafCellPositionFactorY(get, never): Float;

			/**
				@return The local index of the leaf `Cell` that contains the position `x, y`.
			**/
			static inline function getLeafCellLocalIndex(
				x: Float,
				y: Float
			): broker.collision.cell.LocalCellIndex {
				return if (x < 0 || x >= width || y < 0 || y >= height) {
					broker.collision.cell.LocalCellIndex.none;
				} else {
					final cellPositionX = banker.type_extension.FloatExtension.toInt(x * leafCellPositionFactorX);
					final cellPositionY = banker.type_extension.FloatExtension.toInt(y * leafCellPositionFactorY);

					final indexValue = banker.types.Bits.zip(
						banker.types.Bits.from(cellPositionX),
						banker.types.Bits.from(cellPositionY)
					);

					new broker.collision.cell.LocalCellIndex(indexValue.toInt());
				}
			}

			/**
				@return New `Quadtree` with the specified `PartitionLevel`.
			**/
			public static inline function createQuadtree(): broker.collision.Quadtree {
				return new broker.collision.Quadtree(partitionLevel);
			}

			/**
				@return `GlobalCellIndex` of the finest `Cell` that contains the given AABB.
			**/
			public static inline function getCellIndex(
				leftX: Float,
				topY: Float,
				rightX: Float,
				bottomY: Float
			): broker.collision.cell.GlobalCellIndex {
				final leftTop = getLeafCellLocalIndex(leftX, topY);
				final rightBottom = getLeafCellLocalIndex(rightX, bottomY);

				return if (leftTop.isNone() && rightBottom.isNone()) {
					broker.collision.cell.GlobalCellIndex.none;
				} else {
					var aabbLevel: broker.collision.cell.PartitionLevel;
					var aabbLocalIndex: broker.collision.cell.LocalCellIndex;

					if (leftTop == rightBottom) {
						aabbLevel = partitionLevel;
						aabbLocalIndex = leftTop;
					} else {
						aabbLevel = broker.collision.cell.LocalCellIndex.getAabbLevel(
							leftTop,
							rightBottom,
							partitionLevel
						);
						final largerLeafCellIndex = broker.collision.cell.LocalCellIndex.max(
							leftTop,
							rightBottom
						); // For avoiding `-1`
						aabbLocalIndex = largerLeafCellIndex.inRoughLevel(
							partitionLevel,
							aabbLevel
						);
					}

					aabbLocalIndex.toGlobal(aabbLevel);
				}
			}

			static extern inline function get_width()
				return $v{widthValue};

			static extern inline function get_height()
				return $v{heightValue};

			static extern inline function get_partitionLevel()
				return new broker.collision.cell.PartitionLevel($v{levelValue});

			static extern inline function get_gridSize()
				return $v{gridSize};

			static extern inline function get_leafCellPositionFactorX()
				return $v{leafCellPositionFactorX};

			static extern inline function get_leafCellPositionFactorY()
				return $v{leafCellPositionFactorY};
		};

		final buildFields = Context.getBuildFields();
		return buildFields.concat(classDef.fields);
	}

	static function validParameterLength(meta: MetadataEntry, validLength: Int): Bool {
		final params = meta.params;
		if (params == null) {
			warn("Missing parameters", meta.pos);
			return false;
		}

		return switch (params.length) {
			case n if (n < validLength):
				warn("Not enough parameters", meta.pos);
				false;
			case n if (n > validLength):
				warn("Too many parameters", meta.pos);
				false;
			default:
				true;
		}
	}

	static function getParameters(localClass: ClassType): Maybe<{
		width: Expr,
		height: Expr,
		level: Expr
	}> {
		final dummyExpression = macro throw "Missing or invalid metadata";
		var width: Expr = dummyExpression;
		var height: Expr = dummyExpression;
		var level: Expr = dummyExpression;

		for (meta in localClass.meta.get()) {
			final params = meta.params;

			switch meta.name {
				case ':broker.width' | ':broker_width':
					if (!validParameterLength(meta, 1)) return null;
					width = params[0];
				case ':broker.height' | ':broker_height':
					if (!validParameterLength(meta, 1)) return null;
					height = params[0];
				case ':broker.partitionLevel' | ':broker_partitionLevel':
					if (!validParameterLength(meta, 1)) return null;
					level = params[0];
				default:
			}
		}

		if (width == dummyExpression) {
			warn("Missing metadata: @:broker.width");
			return null;
		}

		if (height == dummyExpression) {
			warn("Missing metadata: @:broker.height");
			return null;
		}

		if (level == dummyExpression) {
			warn("Missing metadata: @:broker.partitionLevel");
			return null;
		}

		return {
			width: width,
			height: height,
			level: level
		};
	}
}
#end
